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

      property_attributes = Feed.parse_property_node(property_node)
      next if property_attributes.blank?
      next if property_attributes.fetch(:marketing_name, nil).blank?

      # Debug
      # ap property_attributes

      print "["
      property = self.properties.create!(property_attributes)
      create_floorplans_for_property(property, property_node)
      print "]"
    end
  end

  private def create_floorplans_for_property(property, property_node)

    property_node.xpath("Floorplan").each do |floorplan_node|

      floorplan_attributes = Feed.parse_floorplan_node(floorplan_node)
      next if floorplan_attributes.blank?

      # # Debug
      # ap floorplan_attributes

      print "."
      property.floorplans.create!(floorplan_attributes)
    end
  end

  def self.parse_property_node(property_node)
    self.parse_xml_node(property_node, PropertyParser.new(property_node))
  end

  def self.parse_floorplan_node(floorplan_node)
    self.parse_xml_node(floorplan_node, FloorplanParser.new(floorplan_node))
  end

  def self.parse_xml_node(xml_node, parser)
    {}.with_indifferent_access.tap do |attributes|
      parser.attr_names.each do |attr_name|
        attributes[attr_name] = parser.send(attr_name)
      end
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
