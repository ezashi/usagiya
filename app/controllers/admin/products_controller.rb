class Admin::ProductsController < Admin::AdminController
  before_action :set_product, only: [ :show, :edit, :update, :destroy, :toggle_visibility ]

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
    
    respond_to do |format|
      format.html { redirect_to featured_admin_products_path, notice: "「#{@product.name}」をおすすめ商品から削除しました" }
      format.json { render json: { success: true, message: "「#{@product.name}」をおすすめ商品から削除しました" } }
    end
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
    
    respond_to do |format|
      format.html { redirect_to seasonal_admin_products_path, notice: "「#{@product.name}」を季節限定商品から削除しました" }
      format.json { render json: { success: true, message: "「#{@product.name}」を季節限定商品から削除しました" } }
    end
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
    # デバッグ用ログ
    Rails.logger.debug "=== CREATE DEBUG ==="
    Rails.logger.debug "params[:draft]: #{params[:draft].inspect}"
    Rails.logger.debug "params[:publish]: #{params[:publish].inspect}"
    Rails.logger.debug "params[:product][:visible]: #{params[:product][:visible].inspect}"

    # フォームから送信されたvisibleとremove_imageを除外してパラメータを取得
    @product = Product.new(product_params.except(:visible, :remove_image))
    @product.display_order = Product.next_display_order

    # 画像削除フラグの処理（新規作成では通常不要だが念のため）
    if params[:product][:remove_image] == "true"
      @product.image.purge if @product.image.attached?
    end

    # 新規作成時は画像必須チェック
    if !@product.image.attached? && params[:product][:image].blank?
      @product.errors.add(:image, "を選択してください")
      render :new, status: :unprocessable_entity
      return
    end

    # 下書き保存か公開かを判定
    # params[:draft] が存在すれば下書き、params[:publish] が存在すれば公開
    if params[:draft].present?
      # 下書き保存（visible: false）
      @product.visible = false
      @product.draft_saved_at = Time.current
      Rails.logger.debug "下書き保存: visible = #{@product.visible}, draft_saved_at = #{@product.draft_saved_at}"
      if @product.save
        Rails.logger.debug "保存後の visible: #{@product.reload.visible}, draft_saved_at: #{@product.draft_saved_at}"
        redirect_to edit_admin_product_path(@product), notice: "商品を下書き保存しました"
      else
        render :new, status: :unprocessable_entity
      end
    elsif params[:publish].present?
      # 公開
      @product.visible = true
      @product.draft_saved_at = nil  # 公開時は下書きフラグをクリア
      Rails.logger.debug "公開: visible = #{@product.visible}, draft_saved_at = #{@product.draft_saved_at}"
      if @product.save
        Rails.logger.debug "保存後の visible: #{@product.reload.visible}, draft_saved_at: #{@product.draft_saved_at}"
        @product.update(published_at: Time.current)
        redirect_to admin_products_path, notice: "商品を公開しました"
      else
        render :new, status: :unprocessable_entity
      end
    else
      # どちらも押されていない場合（通常は発生しない）
      @product.errors.add(:base, "保存または公開ボタンを押してください")
      render :new, status: :unprocessable_entity
    end
  end

  # 商品詳細
  def show
    # 商品詳細画面を表示（編集・削除ボタン付き）
  end

  # 編集フォーム
  def edit
    # 下書き内容がある場合は、表示用に下書き内容を優先
    if @product.has_draft?
      @draft_mode = true
      # 下書き内容を一時的に表示用の変数に格納
      @display_name = @product.draft_name || @product.name
      @display_price = @product.draft_price || @product.price
      @display_description = @product.draft_description || @product.description
      @display_featured = @product.draft_featured
      @display_seasonal = @product.draft_seasonal
    else
      @draft_mode = false
      @display_name = @product.name
      @display_price = @product.price
      @display_description = @product.description
      @display_featured = @product.featured
      @display_seasonal = @product.seasonal
    end
  end

  # 商品更新
  def update
    # デバッグ用ログ
    Rails.logger.debug "=== UPDATE DEBUG ==="
    Rails.logger.debug "params[:draft]: #{params[:draft].inspect}"
    Rails.logger.debug "params[:publish]: #{params[:publish].inspect}"
    Rails.logger.debug "params[:product][:visible]: #{params[:product][:visible].inspect}"
    Rails.logger.debug "Before update - visible: #{@product.visible}"

    # 画像削除フラグの処理
    if params[:product][:remove_image] == "true"
      @product.image.purge if @product.image.attached?
    end

    # 下書き保存か公開かを判定
    if params[:draft].present?
      # 下書き保存
      if @product.visible?
        # 公開中の商品の場合: 下書き内容として保存（本体は変更しない）
        Rails.logger.debug "公開中の商品の下書き保存 - 本体は変更せず、下書き内容を保存"

        draft_params = product_params.except(:visible, :remove_image, :image)
        Rails.logger.debug "draft_params: #{draft_params.inspect}"
        Rails.logger.debug "draft_params[:name]: #{draft_params[:name].inspect}"
        Rails.logger.debug "draft_params[:price]: #{draft_params[:price].inspect}"

        @product.save_as_draft(draft_params)

        # 画像の処理（新しい画像がアップロードされた場合）
        if params[:product][:image].present?
          # 下書き用の画像として添付（後で実装）
          @product.image.attach(params[:product][:image])
        end

        Rails.logger.debug "下書き保存完了 - draft_name: #{@product.draft_name}, draft_price: #{@product.draft_price}"
        redirect_to edit_admin_product_path(@product), notice: "変更を下書き保存しました（公開中の内容はそのままです）"
      else
        # 非公開の商品の場合: 通常通り本体を更新
        Rails.logger.debug "非公開商品の下書き保存 - 本体を更新"

        update_params = product_params.except(:visible, :remove_image).merge(
          draft_saved_at: Time.current
        )

        if @product.update(update_params)
          Rails.logger.debug "保存後の visible: #{@product.reload.visible}"
          redirect_to edit_admin_product_path(@product), notice: "変更を下書き保存しました"
        else
          render :edit, status: :unprocessable_entity
        end
      end
    elsif params[:publish].present?
      # 公開
      if @product.has_draft?
        # 下書き内容がある場合: 下書き内容を本体に反映
        Rails.logger.debug "下書き内容を公開"

        # 画像の処理
        if params[:product][:image].present?
          @product.image.attach(params[:product][:image])
        end

        if @product.publish_draft
          Rails.logger.debug "公開完了 - visible: #{@product.visible}, draft_saved_at: #{@product.draft_saved_at}"
          redirect_to admin_products_path, notice: "変更を公開しました"
        else
          render :edit, status: :unprocessable_entity
        end
      else
        # 下書き内容がない場合: 通常の更新
        Rails.logger.debug "通常の公開更新"

        update_params = product_params.except(:visible, :remove_image).merge(
          visible: true,
          draft_saved_at: nil
        )

        if @product.update(update_params)
          @product.update(published_at: Time.current) unless @product.published_at
          Rails.logger.debug "公開完了 - visible: #{@product.visible}"
          redirect_to admin_products_path, notice: "変更を公開しました"
        else
          render :edit, status: :unprocessable_entity
        end
      end
    else
      # どちらも押されていない場合（通常は発生しない）
      @product.errors.add(:base, "保存または公開ボタンを押してください")
      render :edit, status: :unprocessable_entity
    end
  end

  # 商品削除
  def destroy
    @product.destroy
    redirect_to admin_products_path, notice: "商品を削除しました"
  end

  # 公開状態の即座切り替え
  def toggle_visibility
    Rails.logger.debug "=== toggle_visibility DEBUG ==="
    Rails.logger.debug "params: #{params.inspect}"
    Rails.logger.debug "params[:id]: #{params[:id]}"
    Rails.logger.debug "params[:visible]: #{params[:visible]}"

    # @product は before_action :set_product で設定済み
    visible = params[:visible] == true || params[:visible] == "true"

    Rails.logger.debug "Product found: #{@product.name}"
    Rails.logger.debug "Current visible: #{@product.visible}"
    Rails.logger.debug "New visible: #{visible}"

    if @product.update(visible: visible)
      Rails.logger.debug "Update successful"
      render json: { success: true, visible: visible }
    else
      Rails.logger.error "Update failed: #{@product.errors.full_messages}"
      render json: { success: false, errors: @product.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    Rails.logger.error "Exception in toggle_visibility: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    render json: { success: false, errors: [ e.message ] }, status: :internal_server_error
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
      :seasonal,
      :display_order,
      :image,
      :remove_image
    )
  end
end
