Rails.application.routes.draw do
  # ルートパス
  root "pages#home"

  # 一般ユーザー向けページ
  resources :products, only: [:show]
  resources :inquiries, only: [:new, :create]

  # おすすめ商品
  get 'featured_products', to: 'featured_products#index'

  # 季節限定商品
  get 'seasonal_products', to: 'seasonal_products#index'

  # お知らせ
  resources :notices, only: [ :index, :show ]

  # その他の静的ページ
  get 'philosophy', to: 'pages#philosophy'
  get 'calendar', to: 'pages#calendar'
  get 'delivery', to: 'pages#delivery'

  # 管理者認証
  # devise_for :admin_users, path: "admin", controllers: {
  #   sessions: "admin/sessions"
  # }

  # # 管理者用ページ
  # namespace :admin do
  #   root "dashboard#index"
  #   resources :products
  #   resources :notices
  #   resources :calendar_events
  #   resources :inquiries, only: [:index, :show]

  #   # おすすめ・季節限定商品の管理
  #   get 'featured_products', to: 'featured_products#index'
  #   post 'featured_products/update_order', to: 'featured_products#update_order'

  #   get 'seasonal_products', to: 'seasonal_products#index'
  #   post 'seasonal_products/update_order', to: 'seasonal_products#update_order'
  # end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end