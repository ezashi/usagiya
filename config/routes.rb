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

    # ダッシュボード
    root to: "dashboard#index"

    # 商品管理
    resources :products do
      member do
        patch :toggle_visibility
        post :add_to_featured
        delete :remove_from_featured
        post :add_to_seasonal
        delete :remove_from_seasonal
      end
      collection do
        get :featured
        get :seasonal
        patch :update_featured_order
        patch :update_seasonal_order
      end
    end

    # お知らせ管理
    resources :notices do
      member do
        patch :publish  # 公開/非公開切り替え
      end
    end

    # 営業カレンダー管理
    resources :calendar_events

    # 注文管理
    resources :orders, only: [ :index, :show ] do
    member do
      patch :update_status  # この行を追加
    end
  end

    # お問い合わせ管理
    resources :inquiries, only: [ :index, :show ]
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
