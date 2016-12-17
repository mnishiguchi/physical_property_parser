require "test_helper"

describe PropertiesController do
  let(:property) { properties :one }

  it "gets index" do
    get properties_url
    value(response).must_be :success?
  end

  it "gets new" do
    get new_property_url
    value(response).must_be :success?
  end

  it "creates property" do
    expect {
      post properties_url, params: { property: { amenity_id: property.amenity_id, contact_email: property.contact_email, contact_phone: property.contact_phone, description: property.description, floorplan_id: property.floorplan_id, location_city: property.location_city, location_latitude: property.location_latitude, location_longitude: property.location_longitude, location_state: property.location_state, location_street: property.location_street, location_zip: property.location_zip, marketing_name: property.marketing_name, pet_cat: property.pet_cat, pet_dog: property.pet_dog, website: property.website } }
    }.must_change "Property.count"

    must_redirect_to property_path(Property.last)
  end

  it "shows property" do
    get property_url(property)
    value(response).must_be :success?
  end

  it "gets edit" do
    get edit_property_url(property)
    value(response).must_be :success?
  end

  it "updates property" do
    patch property_url(property), params: { property: { amenity_id: property.amenity_id, contact_email: property.contact_email, contact_phone: property.contact_phone, description: property.description, floorplan_id: property.floorplan_id, location_city: property.location_city, location_latitude: property.location_latitude, location_longitude: property.location_longitude, location_state: property.location_state, location_street: property.location_street, location_zip: property.location_zip, marketing_name: property.marketing_name, pet_cat: property.pet_cat, pet_dog: property.pet_dog, website: property.website } }
    must_redirect_to property_path(property)
  end

  it "destroys property" do
    expect {
      delete property_url(property)
    }.must_change "Property.count", -1

    must_redirect_to properties_path
  end
end
