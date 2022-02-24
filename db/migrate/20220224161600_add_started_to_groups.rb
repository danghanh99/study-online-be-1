class AddStartedToGroups < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :started, :boolean, default: false
  end
end
