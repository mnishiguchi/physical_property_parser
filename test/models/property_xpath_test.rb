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

require "test_helper"

describe PropertyXpath do
  let(:property_xpath) { PropertyXpath.new }

  it "must be valid" do
    value(property_xpath).must_be :valid?
  end
end
