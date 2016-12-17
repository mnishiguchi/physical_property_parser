# == Schema Information
#
# Table name: floorplans
#
#  id             :integer          not null, primary key
#  name           :string
#  square_feet    :json
#  market_rent    :json
#  effective_rent :json
#  bedrooms       :integer
#  bathrooms      :integer
#  availability   :integer
#  property_id    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :floorplan do
    name "MyString"
    square_feet 1
    market_rent 1
    effective_rent 1
    bedrooms 1
    bathrooms 1
    availability 1
    amenity nil
  end
end
