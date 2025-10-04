Rails.application.routes.draw do
  # ルートページ
  root "pages#home"

  # 一般ユーザー向けページ
  namespace :pages do
    get :home
    get :philosophy  # 御菓子処うさぎやの想い
  end

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

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
