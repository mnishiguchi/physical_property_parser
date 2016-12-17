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

  PROPERTY_XPATH_REGEX  = /PhysicalProperty\/Property/
  FLOORPLAN_XPATH_REGEX = /PhysicalProperty\/Property\/Floorplan/
  FIELD_TO_XPATH_MAPPING_FILE_PATH = Rails.root.join("db", "files", "feed_xpaths.yaml")

  # Returns a hash of field to xpath path relative to `Property`.
  def self.for_property
    # Cast the resulting hash.
    slice = Property.column_names - ["id", "feed_id", "created_at", "updated_at"]

    Hash[
      field_to_xpath_mappings.map do |field, xpath|
        if xpath.present?
          [ field, self.relative_to_property(xpath) ]
        end
      end.compact
    ].slice(*slice)
  end

  # Returns a hash of field to xpath path relative to `Floorplan`.
  def self.for_floorplan
    hash = {}

    field_to_xpath_mappings.each do |field, xpath|
      next unless field =~ /floorplan_/
      if xpath.present?
        key   = field.sub("floorplan_", "")
        value = self.relative_to_floorplan(xpath)
        hash[key] = value
      end
    end

    hash
  end

  def self.relative_to_property(xpath)
    raise ArgumentError.new("Invalid xpath") unless xpath =~ PROPERTY_XPATH_REGEX
    xpath.gsub("PhysicalProperty/Property", "")
  end

  def self.relative_to_floorplan(xpath)
    raise ArgumentError.new("Invalid xpath") unless xpath =~ FLOORPLAN_XPATH_REGEX
    xpath.gsub("PhysicalProperty/Property/Floorplan/", "")
  end

  # Returns a hash of field to absolute xpath.
  # NOTE: The mapping is loaded from `db/files/feed_xpaths.yaml` file.
  def self.field_to_xpath_mappings
    @@field_to_xpath_mappings ||= begin
      YAML.load(File.read(FIELD_TO_XPATH_MAPPING_FILE_PATH)).with_indifferent_access
    end
  end
end
