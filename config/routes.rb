Rails.application.routes.draw do
  # 管理画面
  namespace :admin do
    root 'dashboard#index'
    resources :products do
      member do
        patch :toggle_visibility
      end
    end
    resources :notices
    resources :calendar_events
    resources :orders, only: [:index, :show]
    resources :inquiries, only: [:index, :show]
  end

  # 公開ページ
  root "pages#home"

  # おすすめ商品ページ（商品一覧より前に配置）
  get 'products/featured', to: 'products#featured', as: 'featured_products'

  # 商品・お知らせ・注文・お問い合わせ
  resources :products, only: [:index, :show]
  resources :notices, only: [:index, :show]
  resources :orders, only: [:new, :create]
  resources :inquiries, only: [:new, :create]

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
