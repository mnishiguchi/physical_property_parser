# == Schema Information
#
# Table name: field_path_mappings
#
#  id                       :integer          not null, primary key
#  marketing_name           :string
#  website                  :string
#  description              :string
#  contact_phone            :string
#  contact_email            :string
#  street                   :string
#  city                     :string
#  state                    :string
#  zip                      :string
#  latitude                 :string
#  longitude                :string
#  floorplan_name           :string
#  floorplan_square_feet    :string
#  floorplan_market_rent    :string
#  floorplan_effective_rent :string
#  floorplan_bedrooms       :string
#  floorplan_bathrooms      :string
#  floorplan_availability   :string
#  file_floorplan           :string
#  file_property            :string
#  amenities_community      :string
#  amenities_floorplan      :string
#  pet_dog                  :string
#  pet_cat                  :string
#  example_data             :json
#  feed_source_id           :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

FactoryGirl.define do
  factory :field_path_mapping do
    address_1 "MyString"
    address_2 "MyString"
    city "MyString"
    state "MyString"
    zip "MyString"
    latiitude "MyString"
    longitude "MyString"
    marketing_name "MyString"
    phone "MyString"
    email "MyString"
    description "MyString"
    amenities "MyString"
    floorplan_name "MyString"
    floorplan_square_feed "MyString"
    floorplan_market_rent "MyString"
    floorplan_effective_rent "MyString"
    floorplan_bedroops "MyString"
    floorplan_bathrooms "MyString"
    property_file "MyString"
    floorplan_file "MyString"
    feed_source nil
  end
end
