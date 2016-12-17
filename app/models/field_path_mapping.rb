# == Schema Information
#
# Table name: field_path_mappings
#
#  id                       :integer          not null, primary key
#  marketing_name           :string
#  website                  :string
#  description              :string
#  contact_phone            :string
#  contact_email            :string
#  street                   :string
#  city                     :string
#  state                    :string
#  zip                      :string
#  latitude                 :string
#  longitude                :string
#  floorplan_name           :string
#  floorplan_square_feet    :string
#  floorplan_market_rent    :string
#  floorplan_effective_rent :string
#  floorplan_bedrooms       :string
#  floorplan_bathrooms      :string
#  floorplan_availability   :string
#  file_floorplan           :string
#  file_property            :string
#  amenities_community      :string
#  amenities_floorplan      :string
#  pet_dog                  :string
#  pet_cat                  :string
#  example_data             :json
#  feed_source_id           :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class FieldPathMapping < ApplicationRecord
  attr_accessor :scroll

  belongs_to :feed_source

  before_update :set_example_data_for_xpath

  def xpath(field)
    send(field)
  end

  def css_path(field)
    send(field)&.gsub("/", " ")
  end

  def all_xpaths
    @xpaths ||= self.feed_source.xpaths
  end

  def all_css_paths
    @css_paths ||= self.all_xpaths.map { |xpath| xpath.gsub("[]", "").gsub("/", " ") }.compact.uniq
  end

  # Returns a hash of field to css absolute path.
  def field_attributes
    except = [
      "id",
      "feed_source_id",
      "created_at",
      "updated_at",
      "example_data"
    ]
    @field_attributes ||= attributes.except(*except)
  end

  # Returns a hash of field to css path relative to `Property`.
  def for_property
    # Cast the resulting hash.
    slice = Property.column_names - ["id", "feed_id", "created_at", "updated_at"]

    Hash[
      field_attributes.map do |field, css|
        if css.present?
          [ field, FieldPathMapping.css_path_relative_to_property(css) ]
        end
      end.compact
    ].slice(*slice)
  end

  # Returns a hash of field to css path relative to `Floorplan`.
  def for_floorplan
    hash = {}

    field_attributes.each do |field, css|
      next unless field =~ /floorplan_/
      if css.present?
        key   = field.sub("floorplan_", "")
        value = FieldPathMapping.css_path_relative_to_floorplan(css)
        hash[key] = value
      end
    end

    hash
  end

  def self.css_path_relative_to_property(css)
    css.gsub("PhysicalProperty Property", "")
  end

  def self.css_path_relative_to_floorplan(css)
    return "" unless css =~ /PhysicalProperty Property Floorplan/
    css.gsub("PhysicalProperty Property Floorplan", "")
  end

  def example_data_for_field(field)
    example_data_for_xpath(self.send(field))
  end

  def example_data_for_xpath(xpath)
    self.example_data&.fetch(xpath) { "" }
  end

  # Sets to the example_data field a hash of xpaths and example values.
  private def set_example_data_for_xpath
    self.example_data = Hash[
      field_attributes.invert.map do |xpath, _|
        [ xpath, find_example_data_for_xpath(xpath) ]
      end
    ]
  end

  # Returns latest example data for the specified xpath if any.
  private def find_example_data_for_xpath(xpath)
    last_feed_xml = FeedSource.for_url(feed_source.url).feeds.last.raw_xml
    xml_doc       = Nokogiri::XML(last_feed_xml) { |config| config.noerror }

    xpath.present? ? xml_doc.at(xpath).to_s : "" rescue "(error)"
  end
end
