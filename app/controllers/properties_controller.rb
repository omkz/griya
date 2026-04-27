class PropertiesController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  def index
    @properties = Property.where(status: :active)
    @regions = Region.all
    @property_types = Property.property_types.keys

    # Search by query
    if params[:query].present?
      @properties = @properties.where("title ILIKE ? OR description ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end

    # Filter by type
    @properties = @properties.where(property_type: params[:type]) if params[:type].present?

    # Filter by listing type
    @properties = @properties.where(listing_type: params[:listing_type]) if params[:listing_type].present?

    # Filter by region
    @properties = @properties.where(region_id: params[:region_id]) if params[:region_id].present?

    # Sort
    @properties = @properties.order(created_at: :desc)
  end

  def show
    @property = Property.find(params[:id])
  end
end
