class ApartmentCommunity < ApplicationRecord
  validates :external_id, presence: true, uniqueness: true, format: { with: /\A(node|way|relation)\/\d+\z/ }
  validates :name, :latitude, :longitude, :fetched_at, presence: true
  has_many :community_swipes, dependent: :destroy

  def source_url
    "https://www.openstreetmap.org/#{external_id}"
  end

  def distance_from(search)
    return unless search&.latitude && search&.longitude
    GeoDistance.miles(search.latitude, search.longitude, latitude, longitude)
  end
end
