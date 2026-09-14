





class User < ApplicationRecord
  
  
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
