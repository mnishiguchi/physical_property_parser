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

require "test_helper"

describe Property do
  let(:property) { Property.new }

  it "must be valid" do
    value(property).must_be :valid?
  end
end
