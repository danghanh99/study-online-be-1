class AddAdminIdToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :admin_id, :bigint
  end
end
