




class TourRequest < ApplicationRecord
    belongs_to :user
    belongs_to :property

    STATUSES = %w[
        pending
        approved
        denied
        completed
        incomplete
    ].freeze

    validates :requested_date, presence: true
    validates :requested_time, presence: true
    validates :status, presence: true, inclusion: { in: STATUSES }

    validate :requested_date_cannot_be_in_the_past, on: :create
    validate :requested_time_cannot_be_in_the_past, on: :create

    def scheduled_at
        return if requested_date.blank? || requested_time.blank?
        Time.zone.local(
            requested_date.year,
            requested_date.month,
            requested_date.day,
            requested_time.hour,
            requested_time.min,
            requested_time.sec
        )
    end

    def tour_time_passed?
        scheduled_at.present? && scheduled_at <= Time.current
    end

    private
    def requested_date_cannot_be_in_the_past
        if requested_date.present? && requested_date < Date.current
            errors.add(:requested_date, "cannot be in the past")
        end
    end

    def requested_time_cannot_be_in_the_past
        if scheduled_at.present? && scheduled_at <= Time.current
            errors.add(:requested_time, "cannot be in the past")
        end
    end
end
