class PropertyXpathsController < ApplicationController

  # GET /property_xpaths
  def index
    # For populating the selectize form.
    @feed_xpaths = FeedXpath.all
  end
end
