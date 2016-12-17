# == Schema Information
#
# Table name: feeds
#
#  id             :integer          not null, primary key
#  raw_xml        :text             not null
#  xpaths         :string           not null, is an Array
#  feed_source_id :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Feed < ApplicationRecord
  belongs_to :feed_source
  has_many :properties

  validates :raw_xml, uniqueness: true

  before_save :save_feed_xpaths

  def create_properties
    property_nodes = Nokogiri::XML(raw_xml).xpath("PhysicalProperty/Property")
    property_nodes.each do |property_node|

      # Prepare attributes for property with field-path mapping and xml doc.
      property_attributes = PropertyAttributes.new(
                              FeedXpath.for_property,
                              property_node
                            ).attributes

      # Skip if invalid
      next if property_attributes.blank?
      next if property_attributes.fetch("marketing_name", nil).blank?

      # Debug
      # ap property_attributes

      print "["
      create_property_with_floorplans(property_attributes, property_node)
      print "]"
    end
  end

  private def create_property_with_floorplans(property_attributes, property_node)
    property = self.properties.create!(property_attributes)

    property_node.xpath("Floorplan").each do |floorplan_node|

      # Prepare attributes for floorplan with field-path mapping and xml doc.
      floorplan_attributes = FloorplanAttributes.new(
                                FeedXpath.for_floorplan,
                                floorplan_node
                              ).attributes

      # Skip if invalid
      next if floorplan_attributes.blank?

      # Debug
      # ap floorplan_attributes

      print "."
      property.floorplans.create!(floorplan_attributes)
    end
  end

  # before_save
  # Save newly occurred xpaths to the FeedXpath table.
  private def save_feed_xpaths
    self.xpaths.each do |xpath|
      FeedXpath.where(xpath: xpath).first_or_create!
    end
  end
end
