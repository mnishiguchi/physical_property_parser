# We get information from an xml doc based on the feed's field-path mapping.
class PropertyAttributes

  TRUE_REGEX = /^(true|t|yes|y|1)$/i

  def initialize(field_to_xpath_mapping, property_root)
    @field_to_xpath_mapping = field_to_xpath_mapping
    @property_root          = property_root
  end

  def attributes
    property_attributes = {}

    @field_to_xpath_mapping.each do |field, css|
      next if css.blank?

      case field
      when "latitude", "longitude"
        property_attributes[field] = send(field, css)
      when "pet_cat", "pet_dog", "amenities"
        property_attributes[field] = send(field, css)
      else
        property_attributes[field] = @property_root.at_css(css)&.text
      end
    end

    property_attributes
  end


  private
    # ---
    # Parsers corresponding to all the individual attribute names.
    # + The method name must match the attribute name.
    # + Takes in a css path.
    # + Returns a value for the attribute.
    # ---


    def amenities(css)
      # Amenity hashes
      amenity_hashes = @property_root.search(css).map do |node|
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
    def true_keys_from_hash(hash)
      hash&.map { |k,v| k if v =~ TRUE_REGEX }.flatten.compact
    end

    def latitude(css)
      parse_float_string(css)
    end

    def longitude(css)
      parse_float_string(css)
    end

    # FIXME: We still have 0.0's.
    def parse_float_string(css)
      return nil unless css
      text = @property_root.at(css)&.text
      transformed = text&.gsub(/[^0-9\.\-]/,'')&.to_f
      (transformed.blank? || transformed == 0.0) ? text : transformed
    end

    def parse_int_string(css)
      parse_float_string(css)&.to_i
    end

    def pet_cat(css)
      parse_pet_string(css, /cat/i)
    end

    def pet_dog(css)
      parse_pet_string(css, /dog/i)
    end

    def parse_pet_string(css, pet_type_regex)
      # 1. Check the text node.
      text = @property_root.at(css)&.text
      return text if text =~ pet_type_regex

      # 2. Check the children.
      hashes = @property_root.search(css).map { |node| node.to_h }
      hashes.each do |hash|
        return hash if hash.to_s =~ pet_type_regex
      end

      nil
    end
end
