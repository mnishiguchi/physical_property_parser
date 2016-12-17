require "test_helper"

describe FeedXpathsController do
  it "should get index" do
    get feed_xpaths_index_url
    value(response).must_be :success?
  end

end
