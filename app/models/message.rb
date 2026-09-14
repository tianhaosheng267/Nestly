

class Message < ApplicationRecord
  belongs_to :sender,
             class_name: "User",
             foreign_key: "sender_id"

  belongs_to :receiver,
             class_name: "User",
             foreign_key: "receiver_id"

  belongs_to :property

  validates :content, presence: true

  validate :sender_and_receiver_are_different

  private

  def sender_and_receiver_are_different
    if sender_id.present? &&
       receiver_id.present? &&
       sender_id == receiver_id
      errors.add(
        :receiver_id,
        "must be different from sender"
      )
    end
  end
end
