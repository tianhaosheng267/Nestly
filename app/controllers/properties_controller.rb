






class PropertiesController < ApplicationController
  before_action :is_owner, only: [ :destroy, :edit, :update, :delete_image ]
  def index
    @properties = current_user.properties
  end

  def show
    @property = Property.find_by(id: params[:id])
    if @property.nil?
    @properties = Property.all
    flash.now[:alert] = "Property not found"
    render "index"
    end
  end

  def new
     @property = Property.new
  end

  def create
    @property = Property.new property_params
    @property.landlord = current_user
    if @property.save
      set_main_image
      redirect_to @property, notice: "Success! Your property is now visible"
    else
      render "new"
    end
  end

  def property_params
        params.require(:property).permit(:address, :city, :state, :zip, :num_bathrooms, :num_bedrooms, :monthly_rent, :amenities, :pet_friendly, :date_available, :sqft, images: [])
  end

  def edit
    @property = Property.find params[:id]
    render :edit
  end

  def update
    @property = Property.find params[:id]
    if @property.update property_params.except(:images)
      previous_image_count = @property.images.count
      @property.images.attach(property_params[:images]) if property_params[:images].present?
      set_main_image previous_image_count
      flash[:success] = "Property listing is updated!"
      redirect_to @property, notice: "Success! Your property is updated!"
    else
      flash.now[:error] = "Property listing is not updated!"
      render "edit"
    end
  end

  def destroy
    Property.find(params[:id]).destroy
    flash[:success] = "Property deleted"
    redirect_to properties_path
  end

  def is_owner
    @property = current_user.properties.find(params[:id])
  end

  def delete_image
    @property = Property.find(params[:id])
    image = @property.images.find(params[:image_id])
    was_main_image = image.id == @property.main_image_id
    image.purge
    @property.update_column(:main_image_id, nil) if was_main_image
    redirect_to property_edit_path @property
  end

  def set_main_image(previous_image_count = 0)
    selection = params.dig(:property, :main_image_selection)

    if selection&.start_with?("existing:")
      image = @property.images.find_by(id: selection.delete_prefix("existing:").to_i)
    elsif selection&.start_with?("new:")
      image = @property.images.attachments[previous_image_count + selection.delete_prefix("new:").to_i]
    end

    image ||= @property.images.first
    @property.update_column(:main_image_id, image&.id)
  end
end
