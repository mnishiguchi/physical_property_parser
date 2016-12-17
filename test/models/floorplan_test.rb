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

require "test_helper"

describe Floorplan do
  let(:floorplan) { Floorplan.new }

  it "must be valid" do
    value(floorplan).must_be :valid?
  end
end
