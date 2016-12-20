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

  scope :property, ->() { where("xpath ILIKE ?", "/PhysicalProperty/Property[]/%").order(:xpath) }

  # An array of xpaths for properties
  def self.xpaths_relative_to_property
    where("xpath ILIKE ?", "/PhysicalProperty/Property[]/%")
    .order(:xpath)
    .pluck(:xpath)
    .map do |xpath|
      xpath.delete("[]").sub("/PhysicalProperty/Property/", "")
                        .sub("/PhysicalProperty/Property", "")
    end.select(&:presence).uniq
  end

  # An array of xpaths for floorplan
  def self.xpaths_relative_to_floorplan
    where("xpath ILIKE ?", "/PhysicalProperty/Property[]/Floorplan%")
    .order(:xpath)
    .pluck(:xpath)
    .map do |xpath|
      xpath.delete("[]").sub("/PhysicalProperty/Property/Floorplan/", "")
                        .sub("/PhysicalProperty/Property/Floorplan", "")
    end.select(&:presence).uniq
  end
end
