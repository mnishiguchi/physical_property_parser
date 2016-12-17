require "test_helper"

describe FloorplansController do
  let(:floorplan) { floorplans :one }

  it "gets index" do
    get floorplans_url
    value(response).must_be :success?
  end

  it "gets new" do
    get new_floorplan_url
    value(response).must_be :success?
  end

  it "creates floorplan" do
    expect {
      post floorplans_url, params: { floorplan: { amenity_id: floorplan.amenity_id, availability: floorplan.availability, bathrooms: floorplan.bathrooms, bedrooms: floorplan.bedrooms, effective_rent: floorplan.effective_rent, market_rent: floorplan.market_rent, name: floorplan.name, square_feet: floorplan.square_feet } }
    }.must_change "Floorplan.count"

    must_redirect_to floorplan_path(Floorplan.last)
  end

  it "shows floorplan" do
    get floorplan_url(floorplan)
    value(response).must_be :success?
  end

  it "gets edit" do
    get edit_floorplan_url(floorplan)
    value(response).must_be :success?
  end

  it "updates floorplan" do
    patch floorplan_url(floorplan), params: { floorplan: { amenity_id: floorplan.amenity_id, availability: floorplan.availability, bathrooms: floorplan.bathrooms, bedrooms: floorplan.bedrooms, effective_rent: floorplan.effective_rent, market_rent: floorplan.market_rent, name: floorplan.name, square_feet: floorplan.square_feet } }
    must_redirect_to floorplan_path(floorplan)
  end

  it "destroys floorplan" do
    expect {
      delete floorplan_url(floorplan)
    }.must_change "Floorplan.count", -1

    must_redirect_to floorplans_path
  end
end
