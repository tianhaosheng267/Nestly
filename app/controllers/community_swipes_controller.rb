class CommunitySwipesController < ApplicationController
  def create
    community = ApartmentCommunity.find(params[:apartment_community_id])
    known = (current_user.apartment_search&.community_ids || []).include?(community.id) || current_user.community_swipes.exists?(apartment_community: community)
    raise ActiveRecord::RecordNotFound unless known
    swipe = current_user.community_swipes.find_or_initialize_by(apartment_community: community)
    if swipe.update(direction: params[:direction])
      redirect_to params[:return_to] == 'apartments' ? apartments_path : root_path
    else
      redirect_to root_path, alert: swipe.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.community_swipes.find(params[:id]).destroy!
    redirect_to likes_path
  end

  def toggle_pin
    swipe = current_user.community_swipes.find(params[:id])
    swipe.update!(pinned: !swipe.pinned)
    redirect_to likes_path
  end
end
