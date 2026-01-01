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
        patch :toggle_visibility
      end
      collection do
        get :featured
        post "featured/add/:id", to: "products#add_to_featured", as: "add_to_featured"
        delete "featured/remove/:id", to: "products#remove_from_featured", as: "remove_from_featured"
        patch "featured/update_order", to: "products#update_featured_order"
        get :seasonal
        post "seasonal/add/:id", to: "products#add_to_seasonal", as: "add_to_seasonal"
        delete "seasonal/remove/:id", to: "products#remove_from_seasonal", as: "remove_from_seasonal"
        patch "seasonal/update_order", to: "products#update_seasonal_order"
      end
    end

    # 注文管理
    resources :orders, only: [ :index, :show ] do
      collection do
        get :filter
      end
    end

    # お知らせ管理
    resources :notices, only: [ :index, :new, :create, :edit, :update, :destroy ] do
      member do
        patch :publish
        get :preview
      end
    end

    # 営業カレンダー管理
    get "calendar", to: "calendar_events#index", as: "calendar"
    post "calendar/events", to: "calendar_events#create"
    patch "calendar/events/:id", to: "calendar_events#update", as: "calendar_event"
    delete "calendar/events/:id", to: "calendar_events#destroy"
    patch "calendar/events/:id/publish", to: "calendar_events#publish", as: "calendar_event_publish"

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
