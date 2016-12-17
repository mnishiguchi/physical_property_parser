# We get information from an xml doc based on the feed's field-path mapping.
class PropertyAttributes

  TRUE_REGEX = /^(true|t|yes|y|1)$/i

  def initialize(property_field_path_mapping, property_xml_doc={})
    @field_path_mapping = property_field_path_mapping
    @xml_doc            = property_xml_doc
  end

  def attributes
    property_attributes = {}

    @field_path_mapping.each do |field, css|
      next if css.blank?

      case field
      when "latitude", "longitude"
        property_attributes[field] = send(field, css)
      when "pet_cat", "pet_dog", "amenities"
        property_attributes[field] = send(field, css)
      else
        property_attributes[field] = @xml_doc.at_css(css)&.text
      end
    end

    property_attributes
  end


  # ---
  # Parsers corresponding to all the individual attribute names.
  # + The method name must match the attribute name.
  # + Takes in a css path.
  # + Returns a value for the attribute.
  # ---


  private def amenities(css)
    # Amenity hashes
    amenity_hashes = @xml_doc.css(css).map do |node|
      Hash.from_xml(node.to_s)[css.strip]
    end.compact

    # Find values for the keys Community and Floorplan
    community = {}
    floorplan = {}
    amenity_hashes.each do |amenity_hash|
      community = amenity_hash&.fetch("Community") { nil }
      floorplan = amenity_hash&.fetch("Floorplan") { nil }
    end

    if community.present? && floorplan.present?
      return {
        community: true_keys_from_hash(community),
        floorplan: true_keys_from_hash(floorplan),
      }
    end

    keys = amenity_hashes&.map do |hash| hash.keys end.flatten
    if keys.include?("Community")
      community_hash = amenity_hashes.select { |k,v| k =~ /community/i }
      true_keys_from_hash(community_hash)
    end

    if keys.include?("Floorplan")
      floorplan_hash = amenity_hashes.select { |k,v| k =~ /floorplan/i }
      true_keys_from_hash(floorplan_hash)
    end
  end

  # Converts hash to an array of keys for `true` value.
  private def true_keys_from_hash(hash)
    hash&.map { |k,v| k if v =~ TRUE_REGEX }.flatten.compact
  end

  private def latitude(css)
    parse_float_string(css)
  end

  private def longitude(css)
    parse_float_string(css)
  end

  # FIXME: We still have 0.0's.
  private def parse_float_string(css)
    return nil unless css
    text = @xml_doc.at(css)&.text
    transformed = text&.gsub(/[^0-9\.\-]/,'')&.to_f
    (transformed.blank? || transformed == 0.0) ? text : transformed
  end

  private def parse_int_string(css)
    parse_float_string(css)&.to_i
  end

  private def pet_cat(css)
    parse_pet_string(css, /cat/i)
  end

  private def pet_dog(css)
    parse_pet_string(css, /dog/i)
  end

  private def parse_pet_string(css, pet_type_regex)
    # 1. Check the text node.
    text = @xml_doc.at(css)&.text
    if text =~ pet_type_regex
      # http://www.w3schools.com/tags/ref_urlencode.asp
      return text.split('\n')
                 .select { |l| l =~ pet_type_regex }
                 .first&.strip
                 .gsub("\%20", " ")
                 .gsub("\%2C", ",")
                 .gsub("\%2E", ".")
                 .split('.')
                 .select { |l| l =~ pet_type_regex }
                 .first&.strip
    end

    # 2. Check the children.
    hashes = @xml_doc.css(css).map { |node| node.to_h }
    hashes.each do |hash|
      return hash if hash.to_s =~ pet_type_regex
    end

    nil
  end
end
