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
      property_attributes = Feed.parse_property_node(property_node)

      # Debug
      # ap property_attributes

      # Skip if invalid
      next if property_attributes.blank?
      next if property_attributes.fetch(:marketing_name, nil).blank?

      # Debug
      ap property_attributes

      print "["
      property = self.properties.create!(property_attributes)
      create_floorplans_for_property(property, property_node)
      print "]"
    end
  end

  private def create_floorplans_for_property(property, property_node)

    property_node.xpath("Floorplan").each do |floorplan_node|

      # Prepare attributes for floorplan with field-path mapping and xml doc.
      floorplan_attributes = FloorplanAttributes.new(
                                FeedXpath.for_floorplan,
                                floorplan_node
                              ).attributes

      # Debug
      ap floorplan_attributes

      # Skip if invalid
      next if floorplan_attributes.blank?

      # # Debug
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

  def self.parse_property_node(property_node)
    parser = PropertyParser.new(property_node)

    {
      marketing_name:       parser.marketing_name,
      website:              parser.website,
      description:          parser.description,
      contact_phone:        parser.contact_phone,
      contact_email:        parser.contact_email,
      street:               parser.street,
      city:                 parser.city,
      state:                parser.state,
      zip:                  parser.zip,
      latitude:             parser.latitude,
      longitude:            parser.longitude,
      # file_floorplan:       parser.file_floorplan,
      # file_property:        parser.file_property,
      # amenities:            parser.amenities,
      # amenities_community:  parser.amenities_community,
      # amenities_floorplan:  parser.amenities_floorplan,
      # pet_dog:              parser.pet_dog,
      # pet_cat:              parser.pet_cat,
    }.with_indifferent_access
  end
end
