





class User < ApplicationRecord
  has_one :apartment_search, dependent: :destroy
  has_many :community_swipes, dependent: :destroy
  has_many :email_conversations, dependent: :destroy
  has_one :gmail_connection, dependent: :destroy
  
  
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :properties,
           foreign_key: "landlord_id",
           dependent: :destroy

  has_many :tour_requests,
           dependent: :destroy

  has_many :sent_messages,
           class_name: "Message",
           foreign_key: "sender_id",
           dependent: :destroy

  has_many :received_messages,
           class_name: "Message",
           foreign_key: "receiver_id",
           dependent: :destroy

  validates :name,
            presence: true
end
