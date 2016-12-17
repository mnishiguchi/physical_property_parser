# == Schema Information
#
# Table name: properties
#
#  id             :integer          not null, primary key
#  marketing_name :string
#  website        :string
#  description    :text
#  contact_email  :string
#  contact_phone  :string
#  street         :string
#  city           :string
#  state          :string
#  zip            :string
#  latitude       :float
#  longitude      :float
#  pet_dog        :json
#  pet_cat        :json
#  amenities      :json
#  feed_id        :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :property do
    marketing_name "MyString"
    website "MyString"
    description "MyText"
    contact_email "MyString"
    contact_phone "MyString"
    location_street "MyString"
    location_city "MyString"
    location_state "MyString"
    location_zip "MyString"
    location_latitude 1.5
    location_longitude 1.5
    pet_dog false
    pet_cat false
    floorplan nil
    amenity nil
  end
end
