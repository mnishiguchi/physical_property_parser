class FeedXpathsController < ApplicationController
  def index
    @feed_xpaths = FeedXpath.all
  end
end
