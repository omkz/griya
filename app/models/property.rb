# app/models/property.rb
class Property < ApplicationRecord
  belongs_to :user
  belongs_to :region

  # Active Storage for photos and legal docs
  has_many_attached :images
  has_one_attached :certificate

  enum :property_type, { house: 0, land: 1, apartment: 2, commercial: 3 }
  enum :listing_type, { for_sale: 0, for_rent: 1 }
  enum :status, { draft: 0, active: 1, sold: 2, rented: 3, archived: 4 }

  # Validations
  validates :title, :price, :lonlat, presence: true

  # PostGIS scope for radius search
  scope :near_point, ->(lon, lat, distance_meters = 5000) {
    where("ST_DWithin(lonlat, ST_MakePoint(?, ?)::geography, ?)", lon, lat, distance_meters)
  }
end
