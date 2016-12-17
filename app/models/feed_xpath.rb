# == Schema Information
#
# Table name: feed_xpaths
#
#  id         :integer          not null, primary key
#  xpath      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FeedXpath < ApplicationRecord
  validates :xpath, uniqueness: true

  # Returns a hash of field to xpath path relative to `Property`.
  def self.for_property
    # Cast the resulting hash.
    slice = Property.column_names - ["id", "feed_id", "created_at", "updated_at"]

    Hash[
      field_attributes.map do |field, xpath|
        if xpath.present?
          [ field, self.xpath_relative_to_property(xpath) ]
        end
      end.compact
    ].slice(*slice)
  end

  # Returns a hash of field to xpath path relative to `Floorplan`.
  def self.for_floorplan
    hash = {}

    field_attributes.each do |field, xpath|
      next unless field =~ /floorplan_/
      if xpath.present?
        key   = field.sub("floorplan_", "")
        value = self.xpath_relative_to_floorplan(xpath)
        hash[key] = value
      end
    end

    hash
  end

  def self.xpath_relative_to_property(xpath)
    xpath.gsub("PhysicalProperty/Property", "")
  end

  def self.xpath_relative_to_floorplan(xpath)
    return "" unless xpath =~ /PhysicalProperty\/Property\/Floorplan/
    xpath.gsub("PhysicalProperty/Property/Floorplan", "")
  end
end
