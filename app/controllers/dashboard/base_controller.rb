module Dashboard
  class BaseController < ApplicationController
    # Ensure only authenticated users with proper roles can access the dashboard
    # before_action :require_agent_or_admin
    
    layout "dashboard" # Optional: to use a different layout for the dashboard
  end
end
