Rails.application.routes.draw do
  # 管理画面
  namespace :admin do
    root 'dashboard#index'  # 管理画面トップ
    resources :products do
      member do
        patch :toggle_visibility  # 表示/非表示の切り替え
      end
    end
  end

  # 公開ページ
  root "pages#home"

  # 商品・お知らせ・注文・お問い合わせ
  resources :products, only: [:index, :show]
  resources :notices, only: [:index, :show]
  resources :orders, only: [:new, :create]
  resources :inquiries, only: [:new, :create]

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
