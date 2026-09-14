

class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = Message
                .where(sender_id: current_user.id)
                .or(Message.where(receiver_id: current_user.id))
                .includes(:sender, :receiver, :property)
                .order(created_at: :desc)

    @conversations = @messages.group_by do |message|
      if message.sender_id == current_user.id
        other_user_id = message.receiver_id
      else
        other_user_id = message.sender_id
      end

      [ message.property_id, other_user_id ]
    end.values.map(&:first)
  end

  def show
    @property = Property.find(params[:property_id])
    @other_user = User.find(params[:user_id])

    unless conversation_allowed?
      redirect_to messages_path,
                  alert: "You cannot view that conversation."
      return
    end

    load_messages
    @message = Message.new
  end

  def create
    @property = Property.find(message_params[:property_id])
    @other_user = User.find(message_params[:receiver_id])

    unless conversation_allowed?
      redirect_to messages_path,
                  alert: "Message could not be sent."
      return
    end

    @message = Message.new(message_params)
    @message.sender = current_user

    if @message.save
      redirect_to message_conversation_path(
        property_id: @property.id,
        user_id: @other_user.id
      )
    else
      load_messages
      render :show, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(
      :receiver_id,
      :property_id,
      :content
    )
  end

  def load_messages
    sent_messages = Message.where(
      property_id: @property.id,
      sender_id: current_user.id,
      receiver_id: @other_user.id
    )

    received_messages = Message.where(
      property_id: @property.id,
      sender_id: @other_user.id,
      receiver_id: current_user.id
    )

    @messages = sent_messages
                .or(received_messages)
                .order(created_at: :asc)
  end

  def conversation_allowed?
    return false if current_user.id == @other_user.id
    current_user.id == @property.landlord_id ||
      @other_user.id == @property.landlord_id
  end
end
