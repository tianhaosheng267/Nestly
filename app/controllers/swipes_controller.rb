




class SwipesController < ApplicationController
  def deck
    update_filter_preferences

    swiped_ids = Swipe.where(user_id: current_user.id).select(:property_id)
    properties = Property.where.not(id: swiped_ids)

    if session[:max_rent].present?
      properties = properties.where(
        "monthly_rent <= ?",
        session[:max_rent]
      )
    end

    if session[:min_bedrooms].present?
      properties = properties.where(
        "num_bedrooms >= ?",
        session[:min_bedrooms]
      )
    end

    if session[:min_bathrooms].present?
      properties = properties.where(
        "num_bathrooms >= ?",
        session[:min_bathrooms]
      )
    end

    @max_rent = session[:max_rent]
    @min_bedrooms = session[:min_bedrooms]
    @min_bathrooms = session[:min_bathrooms]
    @property = properties.first
  end

  def likes
    @liked_swipes = Swipe.where(user_id: current_user.id, direction: "like")
                         .includes(:property)
                         .order(pinned: :desc, created_at: :desc)
  end

  def destroy
    swipe = Swipe.find_by(id: params[:id], user_id: current_user.id)
    swipe&.destroy
    redirect_to likes_path
  end

  def create
    swipe = Swipe.find_or_initialize_by(
      user_id: current_user.id,
      property_id: params[:property_id]
    )
    swipe.direction = params[:direction]
    swipe.save!
    redirect_to root_path
  end

  def toggle_pin
    swipe = Swipe.find_by(id: params[:id], user_id: current_user.id)
    swipe&.update(pinned: !swipe.pinned)
    redirect_to likes_path
  end

  private
  def update_filter_preferences
    if params[:clear_filters] == "true"
      session.delete(:max_rent)
      session.delete(:min_bedrooms)
      session.delete(:min_bathrooms)
      return
    end
    return unless params[:filters_submitted] == "true"
    session[:max_rent] = params[:max_rent].presence
    session[:min_bedrooms] = params[:min_bedrooms].presence
    session[:min_bathrooms] = params[:min_bathrooms].presence
  end
end
