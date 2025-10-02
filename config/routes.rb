Rails.application.routes.draw do
  # 公開ページ
  root "pages#home"

  resources :products, only: [ :index, :show ]
  resources :notices, only: [ :index, :show ]

  resources :orders, only: [ :new, :create ] do
    collection do
      post :confirm
    end
  end

  resources :inquiries, only: [ :new, :create ]

  get "orders/complete", to: "orders#complete", as: :complete_order
  get "inquiries/complete", to: "inquiries#complete", as: :complete_inquiry

  # 管理画面
  namespace :admin do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    root "dashboard#index"

    resources :products
    resources :notices
    resources :calendar_events
    resources :orders, only: [ :index, :show ]
    resources :inquiries, only: [ :index, :show ]
  end
end
