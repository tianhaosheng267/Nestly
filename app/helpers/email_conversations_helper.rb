module EmailConversationsHelper
  def email_send_token(conversation)
    Rails.application.message_verifier('email-send').generate(
      { 'conversation_id' => conversation.id, 'user_id' => current_user.id, 'nonce' => SecureRandom.uuid }, expires_in: 30.minutes)
  end
end
