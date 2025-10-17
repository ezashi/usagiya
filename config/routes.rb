Rails.application.routes.draw do
  # ルートページ
  root "pages#home"

  # 一般ユーザー向けページ
  namespace :pages do
    get :home
  end

  # 御菓子処うさぎやの想い
  get "pages/spirit", to: "pages#spirit", as: "spirit"

  # 商品関連
  resources :products, only: [ :show ] do
    collection do
      get :featured    # おすすめ商品
      get :seasonal    # 季節限定商品
    end
  end

  # お知らせ
  resources :notices, only: [ :index, :show ]

  # 営業カレンダー
  resources :calendar_events, only: [ :index ]

  # お問い合わせ
  resources :inquiries, only: [ :new, :create ]

  # 冷凍もちパイ注文
  resources :orders, only: [ :new, :create ] do
    collection do
      post :confirm  # 確認画面へのPOST
      get :complete  # 完了画面
    end
  end

  # 管理者向けルート
  namespace :admin do
    # 管理者認証
    get "login", to: "sessions#index", as: "login"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: "logout"

    root to: "dashboard#index"
    get "dashboard", to: "dashboard#index", as: "dashboard"

    # 商品管理
    resources :products do
      member do
        patch :toggle_recommended
        patch :toggle_seasonal
      end
    end

    # おすすめ商品管理
    get "recommended_products", to: "recommended_products#index"
    post "recommended_products/:id/add", to: "recommended_products#add", as: "add_recommended_product"
    delete "recommended_products/:id/remove", to: "recommended_products#remove", as: "remove_recommended_product"
    patch "recommended_products/reorder", to: "recommended_products#reorder"
    post "recommended_products/save", to: "recommended_products#save"
    post "recommended_products/publish", to: "recommended_products#publish"
    get "recommended_products/preview", to: "recommended_products#preview"

    # 季節限定商品管理
    get "seasonal_products", to: "seasonal_products#index"
    post "seasonal_products/:id/add", to: "seasonal_products#add", as: "add_seasonal_product"
    delete "seasonal_products/:id/remove", to: "seasonal_products#remove", as: "remove_seasonal_product"
    patch "seasonal_products/reorder", to: "seasonal_products#reorder"
    post "seasonal_products/save", to: "seasonal_products#save"
    post "seasonal_products/publish", to: "seasonal_products#publish"
    get "seasonal_products/preview", to: "seasonal_products#preview"

    # 注文管理
    resources :orders, only: [ :index, :show ] do
      collection do
        get :filter
      end
    end

    # お知らせ管理
    resources :notices, only: [ :index, :new, :create, :edit, :update, :destroy ] do
      member do
        post :save_draft
        post :publish
        get :preview
      end
    end

    # 営業カレンダー管理
    get "calendar", to: "calendar_events#index", as: "calendar"
    post "calendar/events", to: "calendar_events#create"
    patch "calendar/events/:id", to: "calendar_events#update"
    delete "calendar/events/:id", to: "calendar_events#destroy"

    # お問い合わせ管理
    resources :inquiries, only: [ :index, :show ] do
      collection do
        get :filter
      end
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
