class CreateRegions < ActiveRecord::Migration[8.1]
  def change
    create_table :regions do |t|
      t.string :name, null: false
      t.string :country_code, limit: 2, null: false # e.g., 'ID', 'US', 'NL'
      t.string :region_type # province, city, district, village
      t.integer :parent_id # Self-referencing ID for hierarchy

      # Geographic center for maps
      t.st_point :center_point, geographic: true, srid: 4326

      t.timestamps
    end
    add_index :regions, :parent_id
  end
end
