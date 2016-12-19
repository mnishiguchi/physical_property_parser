require "test_helper"

describe PropertyXpathsController do
  it "should get index" do
    get property_xpaths_index_url
    value(response).must_be :success?
  end

end
