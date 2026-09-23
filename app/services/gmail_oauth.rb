require 'base64'
require 'digest'

class GmailOauth
  SCOPES = %w[https://www.googleapis.com/auth/gmail.readonly https://www.googleapis.com/auth/gmail.send].freeze

  def self.configured?
    %w[GOOGLE_OAUTH_CLIENT_ID GOOGLE_OAUTH_CLIENT_SECRET GOOGLE_OAUTH_REDIRECT_URI].all? { |key| ENV[key].present? }
  end

  def self.authorization_url(state:, verifier:)
    ensure_configured!
    params = {
      client_id: ENV.fetch('GOOGLE_OAUTH_CLIENT_ID'), redirect_uri: ENV.fetch('GOOGLE_OAUTH_REDIRECT_URI'),
      response_type: 'code', scope: SCOPES.join(' '), access_type: 'offline', prompt: 'consent',
      state: state, code_challenge: Base64.urlsafe_encode64(Digest::SHA256.digest(verifier), padding: false), code_challenge_method: 'S256'
    }
    "https://accounts.google.com/o/oauth2/v2/auth?#{URI.encode_www_form(params)}"
  end

  def self.exchange(code:, verifier:)
    tokens = token_request(grant_type: 'authorization_code', code: code, code_verifier: verifier,
      redirect_uri: ENV.fetch('GOOGLE_OAUTH_REDIRECT_URI'))
    raise Integrations::Unauthorized, 'Please grant both read and send access to connect Gmail.' unless (SCOPES - tokens.fetch('scope', '').split).empty?
    raise Integrations::Unauthorized, 'Offline access was not granted. Please reconnect Gmail.' if tokens['refresh_token'].blank?
    tokens
  end

  def self.refresh(refresh_token)
    token_request(grant_type: 'refresh_token', refresh_token: refresh_token)
  end

  def self.revoke(token)
    # Revocation may return an empty body, unlike the JSON API endpoints.
    uri = URI('https://oauth2.googleapis.com/revoke')
    request = Net::HTTP::Post.new(uri)
    request.set_form_data(token: token)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 10) { |http| http.request(request) }
    response.is_a?(Net::HTTPSuccess)
  rescue IOError, SystemCallError, Timeout::Error, SocketError, OpenSSL::SSL::SSLError
    false
  end

  def self.ensure_configured!
    raise Integrations::NotConfigured, 'Gmail is not connected to Nestly yet. Please ask the site owner to enable Gmail.' unless configured?
  end

  def self.token_request(params)
    ensure_configured!
    Integrations::Http.json('https://oauth2.googleapis.com/token', method: :post,
      form: params.merge(client_id: ENV.fetch('GOOGLE_OAUTH_CLIENT_ID'), client_secret: ENV.fetch('GOOGLE_OAUTH_CLIENT_SECRET')))
  end
  private_class_method :token_request
end
