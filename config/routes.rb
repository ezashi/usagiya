Rails.application.routes.draw do
  # Root path
  root "pages#home"

  # Public pages
  resources :products, only: [ :index, :show ]
  resources :notices, only: [ :index, :show ]

  # Orders
  resources :orders, only: [ :new, :create ] do
    collection do
      post :confirm
    end
  end

  # Inquiries
  resources :inquiries, only: [ :new, :create ]

  # Admin namespace
  namespace :admin do
    # Admin authentication
    get "login", to: "sessions#new", as: :login
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout

    # Admin dashboard
    root "dashboard#index"

    # Admin resources
    resources :products do
      member do
        patch :toggle_featured
      end
    end
    resources :notices
    resources :calendar_events
    resources :orders, only: [ :index, :show ]
    resources :inquiries, only: [ :index, :show ]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
