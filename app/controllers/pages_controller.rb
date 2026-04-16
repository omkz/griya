# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  allow_unauthenticated_access only: [:home]
  before_action :resume_session, only: [:home]

  def home
    @featured_properties = Property.where(featured: true).where(status: :active).limit(4)
    @latest_properties = Property.where(status: :active).order(created_at: :desc).limit(6)
  end



end
