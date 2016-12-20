class PropertyXpathsController < ApplicationController

  # GET /property_xpaths
  def index
    # For populating the selectize form.
    @feed_xpaths = FeedXpath.property.pluck(:xpath, :id).map do |xpath, id|
      [ xpath.sub("/PhysicalProperty/Property[]/", "").delete('[]'), id ]
    end.uniq
  end

  def create
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
