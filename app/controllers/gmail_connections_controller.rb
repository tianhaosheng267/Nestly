class GmailConnectionsController < ApplicationController
  def create
    state = SecureRandom.urlsafe_base64(32)
    verifier = SecureRandom.urlsafe_base64(48)
    session[:gmail_oauth] = { state: state, verifier: verifier, user_id: current_user.id, created_at: Time.current.to_i }
    redirect_to GmailOauth.authorization_url(state: state, verifier: verifier), allow_other_host: true
  rescue Integrations::Error => error
    session.delete(:gmail_oauth)
    redirect_to inbox_path, alert: error.message
  end

  def callback
    response.headers['Cache-Control'] = 'no-store'
    pending = session.delete(:gmail_oauth)&.with_indifferent_access
    valid = pending && pending[:user_id] == current_user.id && pending[:created_at].to_i > 10.minutes.ago.to_i &&
      params[:state].present? && ActiveSupport::SecurityUtils.secure_compare(pending[:state], params[:state])
    return redirect_to(inbox_path, alert: 'Gmail connection expired or was not requested. Please try again.') unless valid
    return redirect_to(inbox_path, alert: 'Gmail permission was not granted.') if params[:error].present? || params[:code].blank?

    tokens = GmailOauth.exchange(code: params[:code], verifier: pending[:verifier])
    profile = GmailClient.profile(tokens.fetch('access_token'))
    connection = current_user.gmail_connection || current_user.build_gmail_connection
    if connection.persisted? && connection.email != profile.fetch('emailAddress')
      return redirect_to(inbox_path, alert: 'Disconnect the existing mailbox before connecting a different Gmail account.')
    end
    connection.update!(email: profile.fetch('emailAddress'), access_token: tokens.fetch('access_token'),
      refresh_token: tokens.fetch('refresh_token'), expires_at: tokens.fetch('expires_in').to_i.seconds.from_now)
    redirect_to inbox_path, notice: 'Gmail connected. You can now send inquiries and read replies here.'
  rescue Integrations::Error => error
    redirect_to inbox_path, alert: error.message
  end

  def destroy
    connection = current_user.gmail_connection
    revoked = connection.nil? || GmailOauth.revoke(connection.refresh_token)
    connection&.destroy!
    redirect_to inbox_path, notice: revoked ? 'Gmail disconnected. Your emails remain in Gmail.' : 'Local Gmail access removed. Also remove Nestly in your Google Account permissions to finish revoking access.'
  end
end
