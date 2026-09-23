class ApartmentsController < ApplicationController
  rate_limit to: 5, within: 1.minute, only: :create, by: -> { current_user.id }, with: -> { redirect_to new_apartment_search_path, alert: 'Please wait a minute before searching again.' }

  def new
    @search = ApartmentSearch.new(zip_code: current_user.apartment_search&.zip_code, radius_miles: current_user.apartment_search&.radius_miles || 25)
  end

  def create
    @search = ApartmentSearch.new(search_params)
    @search.user = current_user
    return render(:new, status: :unprocessable_entity) unless @search.valid?
    result = OpenApartmentSearch.new.call(zip_code: @search.zip_code, radius_miles: @search.radius_miles)
    ApartmentSearch.transaction do
      ids = result.fetch(:communities).map do |data|
        community = ApartmentCommunity.find_or_initialize_by(external_id: data.fetch(:external_id))
        community.update!(data.except(:distance).merge(fetched_at: result[:fetched_at] || Time.current))
        community.id
      end
      saved = ApartmentSearch.find_or_initialize_by(user_id: current_user.id)
      saved.update!(zip_code: @search.zip_code, radius_miles: @search.radius_miles, community_ids: ids,
        latitude: result.fetch(:latitude), longitude: result.fetch(:longitude), truncated: result.fetch(:truncated), searched_at: Time.current)
    end
    current_user.association(:apartment_search).reset
    redirect_to apartments_path, notice: 'Your search is ready. Explore the list or start swiping.'
  rescue Integrations::Error => error
    @search.errors.add(:base, error.message)
    render :new, status: :unprocessable_entity
  end

  def index
    @search = current_user.apartment_search
    return redirect_to new_apartment_search_path unless @search
    @communities = ApartmentCommunity.where(id: @search.community_ids).sort_by { |community| community.distance_from(@search) }
    @liked_ids = current_user.community_swipes.where(direction: 'like').pluck(:apartment_community_id)
  end

  def show
    @community = ApartmentCommunity.find(params[:id])
    @search = current_user.apartment_search
    raise ActiveRecord::RecordNotFound unless (@search&.community_ids || []).include?(@community.id) || current_user.community_swipes.exists?(apartment_community: @community)
  end

  private

  def search_params
    params.require(:apartment_search).permit(:zip_code, :radius_miles)
  end
end
