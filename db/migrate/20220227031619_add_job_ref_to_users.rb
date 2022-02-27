class AddJobRefToUsers < ActiveRecord::Migration[6.1]
  def change
    add_reference :users, :job, null: true, foreign_key: true
  end
end
