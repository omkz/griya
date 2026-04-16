class PropertiesController < ApplicationController
  allow_unauthenticated_access only: [:index, :show]

  def index
    @properties = Property.active.all
  end

  def show
    @property = Property.find(params[:id])
  end
end
