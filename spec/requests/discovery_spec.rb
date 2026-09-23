require 'rails_helper'

RSpec.describe 'Apartment discovery', type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { User.create!(name: 'Renter', email: "discovery-#{SecureRandom.hex(6)}@example.test", password: 'password123') }
  let(:community) { ApartmentCommunity.create!(external_id: 'way/12', name: 'Sample Apartments', latitude: 40.06, longitude: -83.02, fetched_at: Time.current) }
  let(:search_data) { { latitude: 40.05, longitude: -83.02, truncated: false, communities: [{ external_id: 'way/12', name: 'Sample Apartments', latitude: 40.06, longitude: -83.02, distance: 0.7 }] } }

  it 'requires login for search and results' do
    get apartments_path
    expect(response).to redirect_to(new_user_session_path)
  end

  it 'redirects an actual login to ZIP onboarding' do
    post user_session_path, params: { user: { email: user.email, password: 'password123' } }
    expect(response).to redirect_to(new_apartment_search_path)
  end

  it 'sends a new user from the root to ZIP onboarding' do
    sign_in user
    get root_path
    expect(response).to redirect_to(new_apartment_search_path)
    follow_redirect!
    expect(response.body).to include('Where do you want to live?', '100 miles')
  end

  it 'allows manual listings without a successful external search' do
    sign_in user
    get root_path(manual: '1')
    expect(response).to have_http_status(:ok)
  end

  it 'imports, shows and swipes communities without duplicating them on a repeated search' do
    sign_in user
    allow_any_instance_of(OpenApartmentSearch).to receive(:call).and_return(search_data)
    2.times { post apartment_search_path, params: { apartment_search: { zip_code: '43214', radius_miles: '50' } } }
    expect(ApartmentCommunity.count).to eq(1)
    expect(user.reload.apartment_search.community_ids).to eq([ApartmentCommunity.first.id])
    follow_redirect!
    expect(response.body).to include('Sample Apartments', 'OpenStreetMap')
    get root_path
    expect(response.body).to include('Sample Apartments')
    post community_swipes_path, params: { apartment_community_id: ApartmentCommunity.first.id, direction: 'like' }
    get likes_path
    expect(response.body).to include('Sample Apartments')
    get apartment_path(ApartmentCommunity.first)
    expect(response.body).to include('Contact by email')
  end

  it 'retains previous search and favorites after provider failure' do
    sign_in user
    user.create_apartment_search!(zip_code: '43214', radius_miles: 50, community_ids: [community.id], searched_at: Time.current)
    user.community_swipes.create!(apartment_community: community, direction: 'like')
    allow_any_instance_of(OpenApartmentSearch).to receive(:call).and_raise(Integrations::Unavailable, 'Search is busy')
    post apartment_search_path, params: { apartment_search: { zip_code: '10001', radius_miles: 25 } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(user.reload.apartment_search.zip_code).to eq('43214')
    expect(user.community_swipes.count).to eq(1)
  end

  it 'rejects invalid inputs without calling the provider' do
    sign_in user
    expect_any_instance_of(OpenApartmentSearch).not_to receive(:call)
    post apartment_search_path, params: { apartment_search: { zip_code: '12', radius_miles: 500 } }
    expect(response).to have_http_status(:unprocessable_entity)
  end

  it 'blocks another user from swiping an unrelated imported community' do
    sign_in user
    post community_swipes_path, params: { apartment_community_id: community.id, direction: 'like' }
    expect(response).to have_http_status(:not_found)
  end

  it 'shows both manual properties and discovered communities in the deck' do
    sign_in user
    user.create_apartment_search!(zip_code: '43214', radius_miles: 50, latitude: 40.05, longitude: -83.02, community_ids: [community.id], searched_at: Time.current)
    property = user.properties.create!(address: '42 Example Street', city: 'Columbus', state: 'OH', zip: '43214', monthly_rent: 1500, num_bathrooms: 1, num_bedrooms: 1)
    Property.where.not(id: property.id).find_each { |other| Swipe.create!(user: user, property: other, direction: 'pass') }
    # Start the alternating deck on a community regardless of existing fixtures.
    if Swipe.where(user: user).count.odd?
      get root_path
      expect(response.body).to include(property.address)
      post swipes_path, params: { property_id: property.id, direction: 'pass' }
    end
    get root_path
    expect(response.body).to include(community.name)
    post community_swipes_path, params: { apartment_community_id: community.id, direction: 'pass' }
    Swipe.where(user: user, property: property).delete_all
    get root_path
    expect(response.body).to include(property.address)
  end
end
