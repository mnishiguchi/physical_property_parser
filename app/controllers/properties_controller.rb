class PropertiesController < ApplicationController
  before_action :set_property, only: [:show]

  # GET /properties
  # GET /properties.json
  def index
    @properties = if params["q"].present?
                  then Property.all.by_city_state(params["q"])
                  else Property.all
                  end
    respond_to do |format|
      format.html {}
      format.json {
        # This is a temp solution to ignore records without latitude & longitude
        render json: @properties.where.not(longitude: nil)
                                .where.not(latitude: 0.0)
                                .where.not(city: nil)
      }
    end
  end

  # GET /properties/1
  # GET /properties/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json { render json: @property }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.includes(:feed, :floorplans).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def property_params
      params.require(:property).permit(
        :marketing_name,
        :website,
        :description,
        :contact_email,
        :contact_phone,
        :street,
        :city,
        :state,
        :zip,
        :latitude,
        :longitude,
        :pet_dog,
        :pet_cat,
        :amenities,
        { floorplan_ids: [] },
      )
    end
end
