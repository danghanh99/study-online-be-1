class CreateGroups < ActiveRecord::Migration[6.1]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :code
      t.string :url
      t.string :description
      t.integer :members_number

      t.timestamps
    end
  end
end
