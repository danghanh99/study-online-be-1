class AddCategoryRefToGroups < ActiveRecord::Migration[6.1]
  def change
    add_reference :groups, :category, null: true, foreign_key: true
  end
end
