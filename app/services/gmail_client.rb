require 'mail'

class GmailClient
  def initialize(connection)
    @connection = connection
  end

  def self.profile(access_token)
    Integrations::Http.json('https://gmail.googleapis.com/gmail/v1/users/me/profile', headers: { 'Authorization' => "Bearer #{access_token}" })
  end

  def thread(conversation)
    return [] if conversation.gmail_thread_id.blank?
    data = request("threads/#{CGI.escape(conversation.gmail_thread_id)}?format=full")
    data.fetch('messages', []).map do |message|
      payload = message.fetch('payload', {})
      headers = payload.fetch('headers', []).to_h { |header| [header.fetch('name').downcase, header.fetch('value')] }
      { id: message['id'], from: headers['from'], date: headers['date'], subject: headers['subject'],
        message_id: headers['message-id'], references: headers['references'],
        body: text_body(payload).presence || CGI.unescapeHTML(message['snippet'].to_s) }
    end
  end

  def send_message(conversation, body)
    raise Integrations::Error, 'Write a message between 1 and 10,000 characters.' unless body.to_s.strip.length.between?(1, 10_000)
    previous = thread(conversation).last
    mail = Mail.new
    mail.from = @connection.email
    mail.to = conversation.recipient
    mail.subject = conversation.subject
    mail.charset = 'UTF-8'
    mail.body = body
    if previous && previous[:message_id].present?
      mail.in_reply_to = previous[:message_id]
      mail.references = [previous[:references], previous[:message_id]].compact.join(' ')
    end
    data = { raw: Base64.urlsafe_encode64(mail.encoded, padding: false) }
    data[:threadId] = conversation.gmail_thread_id if conversation.gmail_thread_id.present?
    request('messages/send', method: :post, body: data)
  end

  private

  def request(path, method: :get, body: nil)
    @connection.with_lock do
      if @connection.expires_at.nil? || @connection.expires_at < 1.minute.from_now
        tokens = GmailOauth.refresh(@connection.refresh_token)
        @connection.update!(access_token: tokens.fetch('access_token'), expires_at: tokens.fetch('expires_in').to_i.seconds.from_now)
      end
    end
    Integrations::Http.json("https://gmail.googleapis.com/gmail/v1/users/me/#{path}", method: method,
      headers: { 'Authorization' => "Bearer #{@connection.access_token}" }, body: body)
  end

  def text_body(payload)
    if payload['mimeType'] == 'text/plain' && payload.dig('body', 'data').present?
      Base64.urlsafe_decode64(payload.dig('body', 'data')).force_encoding('UTF-8').scrub
    else
      payload.fetch('parts', []).map { |part| text_body(part) }.reject(&:blank?).join("\n")
    end
  rescue ArgumentError
    ''
  end
end
