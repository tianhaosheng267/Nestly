


class TourRequestsController < ApplicationController
    before_action :set_owned_tour_request, only: [:approve, :deny, :complete, :incomplete]

    def index
        @tour_requests = current_user.tour_requests
                                     .includes(:property)
                                     .order(created_at: :desc)
    end

    def received
        @tour_requests = TourRequest.joins(:property)
                                     .where(properties: { landlord_id: current_user.id })
                                     .includes(:user, :property)
                                     .order(requested_date: :asc, requested_time: :asc)
    end

    def new
        @property = Property.find(params[:property_id])
        if @property.landlord == current_user
            redirect_to property_path(@property), alert: "You cannot request a tour for your own property."
            return
        end
        @tour_request = current_user.tour_requests.new(property: @property)
    end

    def create
        @tour_request = current_user.tour_requests.new(tour_request_params)
        if @tour_request.property.landlord == current_user
            redirect_to property_path(@tour_request.property_id), alert: "You cannot request a tour for your own property."
            return
        end
        if @tour_request.save
            redirect_to property_path(@tour_request.property_id), notice: "Tour request submitted successfully!"
        else
            @property = @tour_request.property
            render :new, status: :unprocessable_entity
        end
    end

    def approve
        unless @tour_request.status == "pending"
            redirect_to received_tour_requests_path, alert: "Only pending requests can be approved."
            return
        end
        @tour_request.update!(status: "approved")
        redirect_to received_tour_requests_path, notice: "Tour request approved."
    end

    def deny
        unless @tour_request.status == "pending"
            redirect_to received_tour_requests_path, alert: "Only pending requests can be denied."
            return
        end
        @tour_request.update!(status: "denied")
        redirect_to received_tour_requests_path, notice: "Tour request denied."
    end

    def complete
        unless completion_status_allowed?
            return
        end
        @tour_request.update!(status: "completed")
        redirect_to received_tour_requests_path, notice: "Tour marked as completed."
    end

    def incomplete
        unless completion_status_allowed?
            return
        end
        @tour_request.update!(status: "incomplete")
        redirect_to received_tour_requests_path, notice: "Tour marked as incomplete."
    end

    private
    def tour_request_params
        params.require(:tour_request).permit(
            :property_id,
            :requested_date,
            :requested_time,
            :message
        )
    end

    def set_owned_tour_request
        @tour_request = TourRequest.find_by(id: params[:id])
        if @tour_request.nil? || @tour_request.property.landlord != current_user
            redirect_to received_tour_requests_path, alert: "You cannot update that tour request."
        end
    end

    def completion_status_allowed?
        if @tour_request.status != "approved"
            redirect_to received_tour_requests_path, alert: "Only approved tours can be completed."
        elsif !@tour_request.tour_time_passed?
            redirect_to received_tour_requests_path, alert: "The scheduled tour time has not passed yet."
        end
        @tour_request.status == "approved" && @tour_request.tour_time_passed?
    end
end

