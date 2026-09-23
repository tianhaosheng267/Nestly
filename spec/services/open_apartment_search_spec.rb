require 'rails_helper'

RSpec.describe OpenApartmentSearch do
  let(:zip_data) { { 'places' => [{ 'latitude' => '40.05', 'longitude' => '-83.02' }] } }
  def element(id, name: 'Sample Apartments', lat: 40.06, lon: -83.02)
    { 'type' => 'way', 'id' => id, 'center' => { 'lat' => lat, 'lon' => lon }, 'tags' => { 'name' => name, 'building' => 'apartments' } }
  end

  it 'filters the actual radius, removes nearby duplicate buildings, and keeps distant communities with the same name' do
    allow(Integrations::Http).to receive(:json).with('https://api.zippopotam.us/us/43214').and_return(zip_data)
    expect(Integrations::Http).to receive(:json).with(anything, hash_including(method: :post, form: { data: a_string_including('out center tags 201') })).and_return(
      'elements' => [element(1), element(2, lat: 40.0601), element(3, lat: 40.1), element(4, lat: 42)])
    result = described_class.new.call(zip_code: '43214', radius_miles: 50)
    expect(result[:communities].map { |entry| entry[:external_id] }).to eq(%w[way/1 way/3])
    expect(result[:communities].first[:address]).to be_nil
  end

  it 'rejects invalid ZIP input before any network call' do
    expect(Integrations::Http).not_to receive(:json)
    expect { described_class.new.call(zip_code: '43214;query', radius_miles: 50) }.to raise_error(Integrations::Error)
  end

  it 'excludes unit codes and institutional or condominium records' do
    allow(Integrations::Http).to receive(:json).and_return(zip_data, { 'elements' => [element(1, name: 'A2'), element(2, name: 'N/A'), element(3, name: 'Tower Residence Hall'), element(4, name: 'Wall Street Condominiums'), element(5)] })
    expect(described_class.new.call(zip_code: '43214', radius_miles: 50)[:communities].map { |entry| entry[:external_id] }).to eq(['way/5'])
  end

  it 'does not pass partial timeout results off as a successful search' do
    allow(Integrations::Http).to receive(:json).and_return(zip_data, { 'remark' => 'runtime error: timeout', 'elements' => [] })
    expect { described_class.new.call(zip_code: '43214', radius_miles: 100) }.to raise_error(Integrations::Unavailable)
  end

  it 'identifies provider truncation' do
    allow(Integrations::Http).to receive(:json).and_return(zip_data, { 'elements' => Array.new(201) { |i| element(i, name: "Community #{i}") } })
    result = described_class.new.call(zip_code: '43214', radius_miles: 100)
    expect(result[:truncated]).to be true
    expect(result[:communities].size).to eq(200)
  end
end
