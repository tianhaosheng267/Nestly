class Swipe < ApplicationRecord
  belongs_to :user
  belongs_to :property

  validates :direction, inclusion: { in: %w[like pass] }
  validates :property_id, uniqueness: { scope: :user_id }
end


