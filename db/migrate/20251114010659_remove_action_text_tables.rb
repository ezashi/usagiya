class RemoveActionTextTables < ActiveRecord::Migration[8.0]
  def up
    drop_table :action_text_rich_texts if table_exists?(:action_text_rich_texts)
    drop_table :active_storage_attachments if table_exists?(:active_storage_attachments) # 画像を使用していない場合のみ
    drop_table :active_storage_blobs if table_exists?(:active_storage_blobs) # 画像を使用していない場合のみ
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
