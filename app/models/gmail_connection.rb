class GmailConnection < ApplicationRecord
  belongs_to :user
  has_many :email_conversations, dependent: :destroy
  encrypts :access_token, :refresh_token
  validates :email, presence: true
end
