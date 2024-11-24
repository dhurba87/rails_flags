module RailsFlags
  class AdminController < ApplicationController
    def index
      @feature_flags = RailsFlags.all_flags
    end

    def create
      RailsFlags.register(
        params[:name],
        enabled: params[:enabled] == "1",
        description: params[:description]
      )
      redirect_to admin_path, notice: "Feature flag created successfully"
    rescue StandardError => e
      redirect_to admin_path, alert: e.message
    end

    def update
      if params[:enabled] == "1"
        RailsFlags.enable(params[:name])
      else
        RailsFlags.disable(params[:name])
      end
      redirect_to admin_path, notice: "Feature flag updated successfully"
    rescue StandardError => e
      redirect_to admin_path, alert: e.message
    end

    def destroy
      RailsFlags.delete(params[:name])
      redirect_to admin_path, notice: "Feature flag deleted successfully"
    rescue StandardError => e
      redirect_to admin_path, alert: e.message
    end
  end
end
