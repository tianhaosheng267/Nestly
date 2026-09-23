class EmailDelivery < ApplicationRecord
  belongs_to :email_conversation
  validates :request_token, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[sending sent failed unknown] }
end
