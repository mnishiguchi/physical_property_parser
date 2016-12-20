class PropertyXpathsController < ApplicationController

  # GET /property_xpaths
  def index
    # An array of all the unique xpaths for populating the selectize form.
    @feed_xpaths = FeedXpath.xpaths_relative_to_property

    # For the form
    @property_xpath = PropertyXpath.new
  end

  def create
    # FIXME
    if params[:property_xpaths].present?
      ids = params[:property_xpaths].map(&:to_i)
      FeedXpath.where(id: ids).update_all(type: "PropertyXpath")
      flash[:success] = "Property xpaths were successfully updated"
    else
      flash[:danger] = "Could not update property xpaths"
    end

    redirect_to property_xpaths_url
  end
end
