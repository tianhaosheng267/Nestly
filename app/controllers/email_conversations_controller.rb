class EmailConversationsController < ApplicationController
  before_action :no_cache
  before_action :require_mailbox, only: [:new, :create, :show, :send_message]

  def index
    @connection = current_user.gmail_connection
    @conversations = current_user.email_conversations.order(updated_at: :desc)
  end

  def new
    @conversation = current_user.email_conversations.new(subject: 'Apartment availability inquiry')
    set_target
    @conversation.recipient = @property.landlord.email if @property
    @conversation.recipient = @community.contact_email if @community
  end

  def create
    @conversation = current_user.email_conversations.new(conversation_params)
    @conversation.gmail_connection = current_user.gmail_connection
    set_target
    if @conversation.save
      redirect_to email_conversation_path(@conversation)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @conversation = current_user.email_conversations.find(params[:id])
    @emails = GmailClient.new(current_user.gmail_connection).thread(@conversation)
  rescue Integrations::Error => error
    @emails = []
    @mail_error = error.message
  end

  def send_message
    @conversation = current_user.email_conversations.find(params[:id])
    signed = Rails.application.message_verifier('email-send').verified(params[:send_token].to_s)
    unless signed && signed['conversation_id'] == @conversation.id && signed['user_id'] == current_user.id
      return redirect_to(email_conversation_path(@conversation), alert: 'This send form expired. Please review and send again.')
    end
    body = params[:body].to_s.strip
    unless body.length.between?(1, 10_000)
      return redirect_to(email_conversation_path(@conversation), alert: 'Write a message between 1 and 10,000 characters.')
    end
    delivery = @conversation.email_deliveries.create!(request_token: signed.fetch('nonce'))
    result = GmailClient.new(current_user.gmail_connection).send_message(@conversation, body)
    @conversation.update!(gmail_thread_id: result.fetch('threadId'), updated_at: Time.current)
    delivery.update!(status: 'sent')
    redirect_to email_conversation_path(@conversation), notice: 'Email sent from your Gmail account.'
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
    redirect_to email_conversation_path(@conversation), alert: 'This send request was already handled. Refresh the conversation to check its status.'
  rescue Integrations::Error, KeyError => error
    delivery&.update!(status: 'unknown')
    redirect_to email_conversation_path(@conversation), alert: 'Delivery could not be confirmed. Refresh this conversation and check Gmail Sent before sending again.'
  end

  private

  def no_cache
    response.headers['Cache-Control'] = 'no-store'
  end

  def require_mailbox
    redirect_to inbox_path, alert: 'Connect Gmail first to contact an apartment inside Nestly.' unless current_user.gmail_connection
  end

  def conversation_params
    params.require(:email_conversation).permit(:recipient, :subject)
  end

  def set_target
    target = params[:email_conversation].presence || params
    if target[:apartment_community_id].present?
      @community = ApartmentCommunity.find(target[:apartment_community_id])
      ids = current_user.apartment_search&.community_ids || []
      known = ids.include?(@community.id) || current_user.community_swipes.exists?(apartment_community: @community)
      raise ActiveRecord::RecordNotFound unless known
      @conversation.apartment_community = @community
    elsif target[:property_id].present?
      @property = Property.find(target[:property_id])
      @conversation.property = @property
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
