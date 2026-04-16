# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  allow_unauthenticated_access only: [:home]
  before_action :resume_session, only: [:home]

  def home
    # Fetch the 3 latest active properties to show on home
    # @featured_properties = Property.active.limit(3).order(created_at: :desc)

    @featured_properties = Property.where(status: :active).limit(6)
   
  end


end
