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

class Floorplan < ApplicationRecord
  belongs_to :property

  # has_many :floorplan_floorplan_amenities, dependent: :destroy
  # has_many :floorplan_amenities, through: :floorplan_floorplan_amenities
end
