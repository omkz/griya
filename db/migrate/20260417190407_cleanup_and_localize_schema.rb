class CleanupAndLocalizeSchema < ActiveRecord::Migration[8.1]
  def up
    # 1. Remove foreign keys first
    remove_foreign_key :properties, :accounts if foreign_key_exists?(:properties, :accounts)
    remove_foreign_key :users, :accounts if foreign_key_exists?(:users, :accounts)

    # 2. Remove columns
    remove_column :properties, :account_id
    remove_column :properties, :currency
    remove_column :users, :account_id
    remove_column :regions, :country_code

    # 3. Drop accounts table
    drop_table :accounts

    # 4. Change price to bigint
    change_column :properties, :price, :bigint
  end

  def down
    # This refactor is one-way for simplicity, but I'll add basic rollbacks if needed
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :subdomain
      t.string :custom_domain
      t.timestamps
    end
    add_column :properties, :account_id, :bigint
    add_column :properties, :currency, :string, limit: 3, default: "IDR"
    add_column :users, :account_id, :bigint
    add_column :regions, :country_code, :string, limit: 2
    change_column :properties, :price, :decimal, precision: 15, scale: 2
  end
end
