class ModifyAdminUsersForCustomAuth < ActiveRecord::Migration[8.0]
  def change
    # emailをlogin_idに変更
    rename_column :admin_users, :email, :login_id

    # login_idのインデックスを再作成
    remove_index :admin_users, :login_id if index_exists?(:admin_users, :login_id)
    add_index :admin_users, :login_id, unique: true
  end
end
