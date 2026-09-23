







class Property < ApplicationRecord
  validates :address, presence: true
  validates :city, presence: true
  validates :zip, presence: true, format: { with: /\d{5}/, message: "exactly 5 digits" }
  validates :state, presence: true
  validates :monthly_rent, presence: true,  numericality: { greater_than: 100 }
  validates :num_bathrooms, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :num_bedrooms, presence: true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :landlord, class_name: "User"

  has_many :swipes, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :email_conversations, dependent: :destroy
  has_many :tour_requests, dependent: :destroy

  has_many_attached :images

  def main_image
    images.find_by(id: main_image_id) || images.first
  end
end
