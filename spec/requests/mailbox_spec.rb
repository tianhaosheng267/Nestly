require 'rails_helper'

RSpec.describe 'Gmail inbox', type: :request do
  include Devise::Test::IntegrationHelpers
  let(:user) { User.create!(name: 'Renter', email: "mailbox-#{SecureRandom.hex(6)}@example.test", password: 'password123') }
  let(:connection) { user.create_gmail_connection!(email: 'renter@gmail.com', access_token: 'secret-access', refresh_token: 'secret-refresh', expires_at: 1.hour.from_now) }
  let(:community) { ApartmentCommunity.create!(external_id: 'way/12', name: 'Apartments', latitude: 40.06, longitude: -83.02, fetched_at: Time.current) }
  let(:conversation) { user.email_conversations.create!(gmail_connection: connection, apartment_community: community, recipient: 'leasing@example.test', subject: 'Availability') }

  before { sign_in user }

  it 'shows an honest unconfigured state' do
    allow(GmailOauth).to receive(:configured?).and_return(false)
    get inbox_path
    expect(response.body).to include('Gmail connection is not available yet')
    expect(response.body).not_to include('secret-access')
  end

  it 'encrypts OAuth tokens at rest' do
    expect(connection.access_token).to eq('secret-access')
    expect(connection.read_attribute_before_type_cast(:access_token)).not_to include('secret-access')
    expect(connection.read_attribute_before_type_cast(:refresh_token)).not_to include('secret-refresh')
  end

  it 'can delete a manual property after an email conversation was created' do
    property = user.properties.create!(address: '42 Example Street', city: 'Columbus', state: 'OH', zip: '43214', monthly_rent: 1500, num_bathrooms: 1, num_bedrooms: 1)
    thread = user.email_conversations.create!(gmail_connection: connection, property: property, recipient: 'leasing@example.test', subject: 'Availability')
    property.destroy!
    expect(EmailConversation.exists?(thread.id)).to be false
  end

  it 'rejects an unsolicited OAuth callback before exchanging its code' do
    expect(GmailOauth).not_to receive(:exchange)
    get gmail_callback_path, params: { state: 'attacker', code: 'fake' }
    expect(response).to redirect_to(inbox_path)
    expect(user.reload.gmail_connection).to be_nil
  end

  it 'connects the requested mailbox and rejects callback replay' do
    requested_state = nil
    allow(GmailOauth).to receive(:authorization_url) do |state:, verifier:|
      requested_state = state
      expect(verifier.length).to be >= 43
      'https://accounts.google.com/o/oauth2/v2/auth'
    end
    post gmail_connection_path
    expect(GmailOauth).to receive(:exchange).once.with(code: 'valid-code', verifier: anything).and_return('access_token' => 'access', 'refresh_token' => 'refresh', 'expires_in' => 3600)
    allow(GmailClient).to receive(:profile).with('access').and_return('emailAddress' => 'renter@gmail.com')
    get gmail_callback_path, params: { state: requested_state, code: 'valid-code' }
    expect(user.reload.gmail_connection.email).to eq('renter@gmail.com')
    get gmail_callback_path, params: { state: requested_state, code: 'valid-code' }
    expect(response).to redirect_to(inbox_path)
    expect(flash[:alert]).to include('expired')
  end

  it 'never renders email HTML as executable markup' do
    allow_any_instance_of(GmailClient).to receive(:thread).and_return([{ body: '<script>alert(1)</script>', from: 'leasing@example.test' }])
    get email_conversation_path(conversation)
    expect(response.body).to include('&lt;script&gt;')
    expect(response.body).not_to include('<script>alert(1)</script>')
    expect(response.headers['Cache-Control']).to include('no-store')
  end

  it 'blocks access to another users conversation' do
    id = conversation.id
    other = User.create!(name: 'Other', email: "other-#{SecureRandom.hex(6)}@example.test", password: 'password123')
    other.create_gmail_connection!(email: 'other@gmail.com', access_token: 'other', refresh_token: 'other', expires_at: 1.hour.from_now)
    sign_in other
    get email_conversation_path(id)
    expect(response).to have_http_status(:not_found)
  end

  it 'sends once for the same reviewed form and saves the returned thread' do
    signed = Rails.application.message_verifier('email-send').generate({ 'conversation_id' => conversation.id, 'user_id' => user.id, 'nonce' => SecureRandom.uuid }, expires_in: 30.minutes)
    expect_any_instance_of(GmailClient).to receive(:send_message).once.and_return('threadId' => 'gmail-thread-1')
    2.times { post send_message_email_conversation_path(conversation), params: { send_token: signed, body: 'Hello, is a tour available?' } }
    expect(conversation.reload.gmail_thread_id).to eq('gmail-thread-1')
    expect(conversation.email_deliveries.pluck(:status)).to eq(['sent'])
  end

  it 'refuses a forged send form' do
    expect_any_instance_of(GmailClient).not_to receive(:send_message)
    post send_message_email_conversation_path(conversation), params: { send_token: 'fake', body: 'hello' }
    expect(conversation.email_deliveries.count).to eq(0)
  end

  it 'marks uncertain delivery without automatically retrying' do
    signed = Rails.application.message_verifier('email-send').generate({ 'conversation_id' => conversation.id, 'user_id' => user.id, 'nonce' => SecureRandom.uuid }, expires_in: 30.minutes)
    expect_any_instance_of(GmailClient).to receive(:send_message).once.and_raise(Integrations::Unavailable)
    post send_message_email_conversation_path(conversation), params: { send_token: signed, body: 'hello' }
    expect(conversation.email_deliveries.pluck(:status)).to eq(['unknown'])
  end

  it 'disconnects locally even when provider revocation is unavailable' do
    conversation
    allow(GmailOauth).to receive(:revoke).and_return(false)
    delete gmail_connection_path
    expect(user.reload.gmail_connection).to be_nil
    expect(user.email_conversations.count).to eq(0)
    expect(response).to redirect_to(inbox_path)
  end
end
