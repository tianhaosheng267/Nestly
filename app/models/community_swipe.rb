class CommunitySwipe < ApplicationRecord
  belongs_to :user
  belongs_to :apartment_community
  validates :direction, inclusion: { in: %w[like pass] }
  validates :apartment_community_id, uniqueness: { scope: :user_id }
end
