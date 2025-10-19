module Admin::ProductsHelper
  def product_status_badges(product)
    badges = []

    # デバッグ情報をログに出力
    Rails.logger.debug "=== BADGE DEBUG for Product ##{product.id} ==="
    Rails.logger.debug "visible: #{product.visible?.inspect}"
    Rails.logger.debug "draft_saved_at: #{product.draft_saved_at.inspect}"
    Rails.logger.debug "draft_name: #{product.draft_name.inspect}"
    Rails.logger.debug "draft_price: #{product.draft_price.inspect}"
    Rails.logger.debug "has_draft?: #{product.has_draft?.inspect}"
    Rails.logger.debug "editing?: #{product.editing?.inspect}"

    # 公開/下書きバッジ
    if product.visible?
      # 公開中の場合
      badges << content_tag(:span, "公開中", class: "product-status-badge status-published")

      # 公開中で下書き保存がある場合は「下書き」バッジも追加
      if product.has_draft?
        badges << content_tag(:span, "下書き", class: "product-status-badge status-draft-editing")
        Rails.logger.debug "下書きバッジを追加（公開中+編集中）"
      end
    else
      # 非公開の場合は「下書き」のみ
      badges << content_tag(:span, "下書き", class: "product-status-badge status-draft")
      Rails.logger.debug "下書きバッジのみ（非公開）"
    end

    safe_join(badges, " ")
  end
end
