class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [ :edit, :update, :destroy, :toggle_featured ]

  def index
    @products = Product.all.recent
    @products = @products.where("name LIKE ?", "%#{params[:search]}%") if params[:search].present?
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_products_path, notice: "商品を追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path, notice: "商品を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "商品を削除しました"
  end

  def toggle_featured
    @product.update(featured: !@product.featured)
    redirect_to admin_products_path, notice: "表示設定を変更しました"
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :price, :description, :featured, :image)
  end
end
