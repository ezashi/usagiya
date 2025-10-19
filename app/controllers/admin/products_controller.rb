class Admin::ProductsController < Admin::AdminController
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  # 商品一覧
  def index
    @products = Product.ordered_by_display.page(params[:page]).per(20)
  end

  # おすすめ商品管理
  def featured
    @featured_products = Product.featured.order(:featured_order)
    @available_products = Product.where(featured: false).order(:name)
  end

  # 季節限定商品管理
  def seasonal
    @seasonal_products = Product.seasonal.order(:seasonal_order)
    @available_products = Product.where(seasonal: false).order(:name)
  end

  # おすすめ商品に追加
  def add_to_featured
    @product = Product.find(params[:id])
    @product.add_to_featured
    redirect_to featured_admin_products_path, notice: "「#{@product.name}」をおすすめ商品に追加しました"
  end

  # おすすめ商品から削除
  def remove_from_featured
    @product = Product.find(params[:id])
    @product.remove_from_featured
    redirect_to featured_admin_products_path, notice: "「#{@product.name}」をおすすめ商品から削除しました"
  end

  # 季節限定商品に追加
  def add_to_seasonal
    @product = Product.find(params[:id])
    @product.add_to_seasonal
    redirect_to seasonal_admin_products_path, notice: "「#{@product.name}」を季節限定商品に追加しました"
  end

  # 季節限定商品から削除
  def remove_from_seasonal
    @product = Product.find(params[:id])
    @product.remove_from_seasonal
    redirect_to seasonal_admin_products_path, notice: "「#{@product.name}」を季節限定商品から削除しました"
  end

  # おすすめ商品の並び順を更新
  def update_featured_order
    params[:order].each_with_index do |id, index|
      Product.find(id).update_column(:featured_order, index + 1)
    end
    head :ok
  end

  # 季節限定商品の並び順を更新
  def update_seasonal_order
    params[:order].each_with_index do |id, index|
      Product.find(id).update_column(:seasonal_order, index + 1)
    end
    head :ok
  end

  # 新規作成フォーム
  def new
    @product = Product.new
  end

  # 商品作成
  def create
    @product = Product.new(product_params)
    @product.display_order = Product.next_display_order

    # 画像削除フラグの処理
    if params[:product][:remove_image] == "true"
      @product.image.purge if @product.image.attached?
    end

    # 下書き保存か公開かを判定
    if params[:commit] == "draft" || params[:draft]
      # 下書き保存（visible: false）
      @product.visible = false
      if @product.save
        redirect_to admin_products_path, notice: "商品を下書き保存しました"
      else
        render :new, status: :unprocessable_entity
      end
    else
      # 公開
      @product.visible = true
      if @product.save
        @product.update(published_at: Time.current)
        redirect_to admin_products_path, notice: "商品を公開しました"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  # 商品詳細
  def show
    # 商品詳細画面を表示（編集・削除ボタン付き）
  end

  # 編集フォーム
  def edit
  end

  # 商品更新
  def update
    # 画像削除フラグの処理
    if params[:product][:remove_image] == "true"
      @product.image.purge if @product.image.attached?
    end

    # 下書き保存か公開かを判定
    if params[:commit] == "保存" || params[:draft]
      # 下書き保存
      if @product.update(product_params.except(:visible))
        redirect_to edit_admin_product_path(@product), notice: "変更を保存しました"
      else
        render :edit, status: :unprocessable_entity
      end
    else
      # 公開
      updated_params = product_params.merge(visible: true)
      if @product.update(updated_params)
        @product.update(published_at: Time.current) unless @product.published_at
        redirect_to admin_products_path, notice: "変更を公開しました"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  # 商品削除
  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "商品を削除しました"
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
      :display_order,
      :image
    )
  end
end
