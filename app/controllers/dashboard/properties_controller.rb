module Dashboard
  class PropertiesController < BaseController
    def index
      # Admins see everything, Agents see only their own listings
      if Current.user.admin?
        @properties = Property.all
      else
        @properties = Current.user.properties
      end

      @properties = @properties.order(created_at: :desc)
    end

    def new
      @property = Property.new
    end

    def create
      @property = Property.new(property_params)
      @property.user = Current.user

      if @property.save
        redirect_to [ :dashboard, @property ], notice: "Properti berhasil ditambahkan!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @property = find_property
    end

    def update
      @property = find_property
      if @property.update(property_params)
        redirect_to [ :dashboard, @property ], notice: "Properti berhasil diperbarui!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def show
      @property = find_property
    end

    def destroy
      @property = find_property
      @property.destroy
      redirect_to dashboard_properties_path, notice: "Properti berhasil dihapus."
    end

    private

    def find_property
      # Extra security: ensure agents can only access their own properties
      if Current.user.admin?
        Property.find(params[:id])
      else
        Current.user.properties.find(params[:id])
      end
    end

    def property_params
      params.require(:property).permit(:title, :description, :price, :listing_type, :property_type, :status, :region_id, :lonlat, :featured, :bedrooms, :bathrooms, :building_area, :surface_area, :floors, :certificate_type, :street_address, images: [])
    end
  end
end
