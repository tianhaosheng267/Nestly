






module SwipesHelper
  
  def cross_icon
    raw '<svg viewBox="0 0 24 24" width="28" height="28" fill="currentColor">
      <path d="M18.3 5.7a1 1 0 0 0-1.4 0L12 10.6 7.1 5.7a1 1 0 0 0-1.4 1.4L10.6 12l-4.9 4.9a1 1 0 1 0 1.4 1.4L12 13.4l4.9 4.9a1 1 0 0 0 1.4-1.4L13.4 12l4.9-4.9a1 1 0 0 0 0-1.4z"/>
    </svg>'
  end
  
  def heart_icon
    raw '<svg viewBox="0 0 24 24" width="28" height="28" fill="currentColor">
      <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
    </svg>'
  end
  
  def home_icon
    raw '<svg viewBox="0 0 24 24" width="26" height="26" fill="currentColor">
      <path d="M12 3l9 8h-3v9h-4v-6h-4v6H5v-9H2l10-8z"/>
    </svg>'
  end
  
  def star_icon
    raw '<svg viewBox="0 0 24 24" width="26" height="26" fill="currentColor">
      <path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-0.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/>
    </svg>'
  end
  
  def chat_icon
    raw '<svg viewBox="0 0 24 24" width="26" height="26" fill="currentColor">
      <path d="M20 2H4c-1.1 0-2 0.9-2 2v18l4-4h14c1.1 0 2-0.9 2-2V4c0-1.1-0.9-2-2-2z"/>
    </svg>'
  end
  
  def tour_icon
    raw '<svg viewBox="0 0 24 24" width="26" height="26" fill="currentColor">
      <path d="M19 4h-1V2h-2v2H8V2H6v2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zm0 16H5V9h14v11zM5 7V6h14v1H5zm2 4h5v5H7v-5z"/>
    </svg>'
  end
  
  def received_tour_icon
    raw '<svg viewBox="0 0 24 24" width="26" height="26" fill="currentColor">
      <path d="M9 2h6a2 2 0 0 1 2 2h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2a2 2 0 0 1 2-2zm0 2v2h6V4H9zm8 5-6 6-3-3 1.4-1.4 1.6 1.6 4.6-4.6L17 9z"/>
    </svg>'
  end
  
  def property_photo(property, css_class = "")
    if property.images.attached?
      image_tag property.main_image, class: css_class, alt: property.address
    else
      image_tag "property-placeholder.jpg", class: css_class, alt: "No photo yet"
    end
  end
  
  def left_icon
    raw '<svg viewBox="0 0 24 24" width="26" height="26" fill="currentColor">
      <path d="M15.41 7.41L14 6l-6 6 6 6 1.41-1.41L10.83 12z"/>
    </svg>'
  end
  
  def right_icon
    raw '<svg viewBox="0 0 24 24" width="26" height="26" fill="currentColor">
      <path d="M8.59 16.59L10 18l6-6-6-6-1.41 1.41L13.17 12z"/>
    </svg>'
  end
end
