class ApartmentSearch < ApplicationRecord
  RADII = [5, 10, 25, 50, 100].freeze
  belongs_to :user
  validates :zip_code, format: { with: /\A\d{5}\z/, message: 'must be a five-digit US ZIP code' }
  validates :radius_miles, inclusion: { in: RADII }
end
