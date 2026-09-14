









Rails.application.routes.draw do
  devise_for :users
  

  mount LetterOpenerWeb::Engine,
      at: "/letter_opener" if Rails.env.development?

  resource :account, only: :show

  
  
  get "up" => "rails/health#show", as: :rails_health_check

  
  
  

  
  
  
  

  
  
  
  
  
  get "/properties", to: "properties#index", as: :properties
  post "/properties", to: "properties#create"
  get "/properties/new", to: "properties#new", as: :property_new
  get "/properties/:id", to: "properties#show", as: :property
  get "/properties/:id/edit", to: "properties#edit", as: :property_edit
  put "/properties/:id", to: "properties#update"
  delete "/properties/:id", to: "properties#destroy"
  delete "/properties/:id/edit/images/:image_id", to: "properties#delete_image", as: :property_image_delete

  
  
  root "swipes#deck"
  get "/likes", to: "swipes#likes"
  post "/swipes", to: "swipes#create"
  delete "/swipes/:id", to: "swipes#destroy"
  delete "/properties/:id", to: "properties#destroy"
  patch "/swipes/:id/pin", to: "swipes#toggle_pin"

  
  
  
  get "/tour_requests", to: "tour_requests#index", as: :tour_requests
  get "/tour_requests/received", to: "tour_requests#received", as: :received_tour_requests
  get "/tour_requests/new", to: "tour_requests#new", as: :new_tour_request
  post "/tour_requests", to: "tour_requests#create"
  put "/tour_requests/:id/approve", to: "tour_requests#approve", as: :approve_tour_request
  put "/tour_requests/:id/deny", to: "tour_requests#deny", as: :deny_tour_request
  put "/tour_requests/:id/complete", to: "tour_requests#complete", as: :complete_tour_request
  put "/tour_requests/:id/incomplete", to: "tour_requests#incomplete", as: :incomplete_tour_request

  
  get "/messages", to: "messages#index"
  post "/messages", to: "messages#create"
  get "/messages/:property_id/:user_id", to: "messages#show", as: :message_conversation
end
