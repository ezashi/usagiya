Rails.application.routes.draw do
  # ルートパス
  root "pages#home"

  # 一般ユーザー向けページ
  namespace :pages do
    get :home
    get :philosophy  # 御菓子処うさぎやの想い
  end

  # 商品関連
  resources :products, only: [ :index, :show ]
  get "featured_products", to: "products#featured"
  get "seasonal_products", to: "products#seasonal"

  # お知らせ
  resources :notices, only: [ :index, :show ]

  # 営業カレンダー
  resources :calendar_events, only: [ :index ] do
    collection do
      get :month  # 月別カレンダー取得用
    end
  end

  # お問い合わせ
  resources :inquiries, only: [ :new, :create ]

  # 冷凍もちパイ注文
  resources :orders, only: [ :new, :create ] do
    member do
      get :confirmation  # 注文確認画面
    end
  end

  # 管理者認証
  devise_for :admin_users, path: "admin", controllers: {
    sessions: "admin/sessions"
  }

  # 管理者用ページ
  namespace :admin do
    root "dashboard#index"

    # 商品管理
    resources :products do
      member do
        patch :publish
        patch :unpublish
        patch :add_to_featured
        patch :remove_from_featured
        patch :add_to_seasonal
        patch :remove_from_seasonal
        patch :update_featured_order
        patch :update_seasonal_order
      end
      collection do
        patch :bulk_update_featured_order
        patch :bulk_update_seasonal_order
      end
    end

    # おすすめ商品管理
    resource :featured_products, only: [ :show, :update ] do
      get :preview
    end

    # 季節限定商品管理
    resource :seasonal_products, only: [ :show, :update ] do
      get :preview
    end

    # お知らせ管理
    resources :notices do
      member do
        patch :publish
        patch :unpublish
        get :preview
      end
    end

    # 営業カレンダー管理
    resources :calendar_events do
      member do
        patch :publish
        patch :unpublish
        get :preview
      end
    end

    # お問い合わせ管理
    resources :inquiries, only: [ :index, :show ] do
      member do
        patch :mark_as_read
        patch :mark_as_unread
      end
    end

    # 注文管理
    resources :orders, only: [ :index, :show, :update ] do
      member do
        patch :update_status
      end
    end
  end

  # API endpoints for React
  namespace :api do
    namespace :v1 do
      resources :products, only: [ :index, :show ]
      resources :notices, only: [ :index, :show ]
      resources :calendar_events, only: [ :index ]
      resources :inquiries, only: [ :create ]
      resources :orders, only: [ :create ]

      namespace :admin do
        resources :products do
          member do
            patch :publish
            patch :unpublish
            patch :add_to_featured
            patch :remove_from_featured
            patch :add_to_seasonal
            patch :remove_from_seasonal
          end
          collection do
            patch :bulk_update_featured_order
            patch :bulk_update_seasonal_order
          end
        end

        resources :notices do
          member do
            patch :publish
            patch :unpublish
          end
        end

        resources :calendar_events do
          member do
            patch :publish
            patch :unpublish
          end
        end

        resources :inquiries, only: [ :index, :show ] do
          member do
            patch :mark_as_read
          end
        end

        resources :orders, only: [ :index, :show, :update ]
      end
    end
  end
end
