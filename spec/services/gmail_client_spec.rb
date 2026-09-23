require 'rails_helper'

RSpec.describe GmailClient do
  it 'encodes a reply with matching thread, subject, References and In-Reply-To' do
    user = User.create!(name: 'Mail user', email: 'mail@example.test', password: 'password123')
    connection = user.create_gmail_connection!(email: 'mail@gmail.com', access_token: 'access', refresh_token: 'refresh', expires_at: 1.hour.from_now)
    community = ApartmentCommunity.create!(external_id: 'way/9', name: 'Homes', latitude: 40, longitude: -83, fetched_at: Time.current)
    conversation = user.email_conversations.create!(gmail_connection: connection, apartment_community: community, recipient: 'office@example.test', subject: 'Tour request', gmail_thread_id: 'thread1')
    client = described_class.new(connection)
    allow(client).to receive(:thread).and_return([{ message_id: '<reply@example.test>', references: '<first@example.test>' }])
    expect(Integrations::Http).to receive(:json) do |url, **options|
      expect(url).to end_with('/messages/send')
      expect(options[:body][:threadId]).to eq('thread1')
      mail = Mail.read_from_string(Base64.urlsafe_decode64(options[:body][:raw]))
      expect(mail.subject).to eq('Tour request')
      expect(mail.in_reply_to).to eq('reply@example.test')
      expect(mail.to).to eq(['office@example.test'])
      { 'threadId' => 'thread1' }
    end
    client.send_message(conversation, 'Thank you, tomorrow works.')
  end
end
