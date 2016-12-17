class FeedSourcesController < ApplicationController
  before_action :set_feed_source, only: [:show]

  # GET /feed_sources
  def index
    @feed_sources = FeedSource.includes(:field_path_mapping).all
  end

  # GET /feed_sources/1
  # GET /feed_sources/1.csv
  def show
    respond_to do |format|
      format.html
      format.csv { SendFeedSourceCsv.new(@feed_source, self) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed_source
      @feed_source = FeedSource.includes(:field_path_mapping).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_source_params
      params.require(:feed_source).permit(:url)
    end
end
