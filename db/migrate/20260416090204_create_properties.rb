class CreateProperties < ActiveRecord::Migration[8.1]
  def change
    create_table :properties do |t|
      # --- SaaS and Ownership ---
      # Linked to Account for multi-tenancy and User for the listing agent
      t.references :account, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
      t.references :region, foreign_key: true, index: true

      # --- Basic Information ---
      t.string :title, null: false
      t.text :description
      t.decimal :price, precision: 15, scale: 2, index: true
      t.string :currency, default: 'IDR', limit: 3

      # --- Property Specifications (Enums) ---
      # 0: house, 1: land, 2: apartment, etc.
      t.integer :property_type, default: 0, index: true
      # 0: for_sale, 1: for_rent
      t.integer :listing_type, default: 0, index: true

      # --- Physical Details ---
      t.integer :surface_area   # Land size in m2
      t.integer :building_area  # Building size in m2
      t.integer :bedrooms, default: 0
      t.integer :bathrooms, default: 0
      t.integer :floors, default: 1
      t.string :certificate_type # SHM, HGB, Freehold, etc.

      # --- Geospatial Data ---
      # Uses PostGIS geography type for accurate meter-based distance (WGS84)
      t.string :street_address
      t.st_point :lonlat, geographic: true, srid: 4326, null: false

      # --- Lifecycle Status (Enum) ---
      # 0: draft, 1: active, 2: sold, 3: rented, 4: archived
      t.integer :status, default: 0, index: true

      t.timestamps
    end

    # Spatial index for high-speed proximity queries
    add_index :properties, :lonlat, using: :gist
  end
end
