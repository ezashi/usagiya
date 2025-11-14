class MigrateFromActionTextToPlainHtml < ActiveRecord::Migration[8.0]
  def up
    # 商品の description を移行
    Product.find_each do |product|
      if product.description.present? && product.description.body.present?
        product.update_column(:description, product.description.body.to_s)
      end
    end

    # お知らせの content を移行
    Notice.find_each do |notice|
      if notice.content.present? && notice.content.body.present?
        notice.update_column(:content, notice.content.body.to_s)
      end
    end
  end

  def down
    # ロールバックは困難なため、警告のみ
    raise ActiveRecord::IrreversibleMigration
  end
end
