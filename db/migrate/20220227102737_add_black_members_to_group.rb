class AddBlackMembersToGroup < ActiveRecord::Migration[6.1]
  def change
    add_column :groups, :black_members, :integer, array: true, default: []
  end
end
