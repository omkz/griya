class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :subdomain
      t.string :custom_domain
      # Add more SaaS-related configs here if needed
      t.timestamps
    end
    add_index :accounts, :subdomain, unique: true
    add_index :accounts, :custom_domain, unique: true
  end
end
