# == Schema Information
#
# Table name: property_xpaths
#
#  id             :integer          not null, primary key
#  marketing_name :string           default([]), is an Array
#  website        :string           default([]), is an Array
#  description    :string           default([]), is an Array
#  contact_phone  :string           default([]), is an Array
#  contact_email  :string           default([]), is an Array
#  street         :string           default([]), is an Array
#  city           :string           default([]), is an Array
#  zip            :string           default([]), is an Array
#  latitude       :string           default([]), is an Array
#  longitude      :string           default([]), is an Array
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

FactoryGirl.define do
  factory :property_xpath do
    marketing_name "MyString"
    website "MyString"
    description "MyString"
    contact_phone "MyString"
    contact_email "MyString"
    street "MyString"
    city "MyString"
    zip "MyString"
    latitude "MyString"
    longitude "MyString"
  end
end
