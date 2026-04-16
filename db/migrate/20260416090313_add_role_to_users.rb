class AddRoleToUsers < ActiveRecord::Migration[8.1]
  def change
    # Adding role as integer with default 0 (customer)
    add_column :users, :role, :integer, default: 0, null: false
    add_index :users, :role
  end
end
