# app/models/property.rb
class Property < ApplicationRecord
  belongs_to :user
  belongs_to :region

  # Active Storage attachments
  has_many_attached :images do |attachable|
    attachable.variant :large, resize_to_limit: [ 1200, 800 ], format: :webp
    attachable.variant :card, resize_to_limit: [ 600, 400 ], format: :webp
    attachable.variant :thumbnail, resize_to_limit: [ 200, 200 ], format: :webp
  end
  has_one_attached :certificate

  enum :property_type, { house: 0, land: 1, apartment: 2, commercial: 3 }
  enum :listing_type, { for_sale: 0, for_rent: 1 }
  enum :status, { draft: 0, active: 1, sold: 2, rented: 3, archived: 4 }

  # Standard validations
  validates :title, :price, :lonlat, presence: true

  # Image validations (requires active_storage_validations gem)
  validates :images,
    content_type: [ :png, :jpg, :jpeg, :webp ],
    size: { less_than: 5.megabytes, message: "is too large (max 5MB per photo)" },
    limit: { min: 1, max: 15, message: "must have between 1 and 15 photos" }

  # Callbacks to trigger background processing
  after_commit :precompute_variants, if: -> { images.attached? }

  # PostGIS scope for radius search (geography-based)
  scope :near_point, ->(lon, lat, distance_meters = 5000) {
    where("ST_DWithin(lonlat, ST_MakePoint(?, ?)::geography, ?)", lon, lat, distance_meters)
  }

  private

  def precompute_variants
    # Enqueue background job to generate image variants for better LCP
    PropertyImageJob.perform_later(self)
  end
end
