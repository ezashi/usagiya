class Admin::ProductsController < ApplicationController
  before_action :set_product, only: [ :edit, :update, :destroy, :toggle_visibility ]

  # 商品一覧
  def index
    @products = Product.ordered.page(params[:page]).per(20)
  end

  # 新規作成フォーム
  def new
    @product = Product.new
  end

  # 商品作成
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_products_path, notice: "商品を登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 編集フォーム
  def edit
  end

  # 商品更新
  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "商品を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 商品削除
  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "商品を削除しました"
  end

  # 表示/非表示の切り替え
  def toggle_visibility
    @product.update(visible: !@product.visible)
    redirect_to admin_products_path, notice: "商品を#{@product.visible? ? '表示' : '非表示'}に設定しました"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(
      :name,
      :price,
      :description,
      :image_filename,
      :category,
      :visible,
      :featured,
      :display_order
    )
  end
end
