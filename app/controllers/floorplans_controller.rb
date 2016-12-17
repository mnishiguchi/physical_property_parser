class FloorplansController < ApplicationController
  before_action :set_floorplan, only: [:show]

  # GET /floorplans
  # GET /floorplans.json
  def index
    @floorplans = Floorplan.all
    respond_to do |format|
      format.html {}
      format.json { render json: @floorplans }
    end
  end

  # GET /floorplans/1
  # GET /floorplans/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_floorplan
      @floorplan = Floorplan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def floorplan_params
      params.require(:floorplan).permit(:name, :square_feet, :market_rent, :effective_rent, :bedrooms, :bathrooms, :availability, :amenity_id)
    end
end
