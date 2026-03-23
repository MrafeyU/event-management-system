Rails.application.routes.draw do
  # routes for device user
  devise_for :users

  # Admin Module /Dashboard/Users 
  namespace :admin do
    root "dashboard#index"
    resources :users 
  end

  # Organizer Module /Dashboard
  namespace :organizer do
    root "dashboard#index"
  end

  # Attendee Module /Dashboard
  namespace :attendee do
    root "dashboard#index"
  end

  # Adding prefix to route url 
  scope "/:role" do
    resources :events do
      collection do
        delete :remove_images
      end
      resources :bookings, only: [:new, :create]
    end
    resources :bookings, only: [:index, :show, :edit, :update, :destroy]
  end


  root "events#index"
end
