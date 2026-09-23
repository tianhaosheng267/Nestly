class EmailConversation < ApplicationRecord
  belongs_to :user
  belongs_to :gmail_connection
  belongs_to :apartment_community, optional: true
  belongs_to :property, optional: true
  has_many :email_deliveries, dependent: :destroy
  validates :recipient, format: { with: /\A[^\s<>@,;]+@[^\s<>@,;]+\.[^\s<>@,;]+\z/ }, length: { maximum: 254 }
  validates :subject, presence: true, length: { maximum: 200 }, format: { without: /[\r\n]/ }
  validate :owned_connection_and_single_target

  private

  def owned_connection_and_single_target
    errors.add(:base, 'Choose one apartment or property') unless [apartment_community_id, property_id].compact.size == 1
    errors.add(:base, 'Mailbox belongs to another user') unless gmail_connection&.user_id == user_id
  end
end
