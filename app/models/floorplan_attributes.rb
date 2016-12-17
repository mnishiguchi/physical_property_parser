# We get information from an xml doc based on the feed's field-path mapping.
class FloorplanAttributes

  def initialize(floorplan_field_path_mapping, floorplan_xml_doc={})
    @field_path_mapping = floorplan_field_path_mapping
    @xml_doc            = floorplan_xml_doc
  end

  def attributes
    floorplan_attributes = {}

    @field_path_mapping.each do |field, css|
      next if css.blank?
      floorplan_attributes[field] = send(field, css)
    end

    floorplan_attributes
  end


  # ---
  # Parsers corresponding to all the individual attribute names.
  # + The method name must match the attribute name.
  # + Takes in a css path.
  # + Returns a value for the attribute.
  # ---


  private def name(css)
    @xml_doc.at(css)&.text
  end

  private def square_feet(css)
    @xml_doc.at(css)&.to_s.scan(/\d+/)[0]
  end

  private def market_rent(css)
    market_rent_and_effective_rent(css)
  end

  private def effective_rent(css)
    market_rent_and_effective_rent(css)
  end

  private def market_rent_and_effective_rent(css)
    # A hash with downcase keys.
    transformed_pair = @xml_doc.at(css)&.to_h&.map { |k, v| [ k.downcase, v ] }

    (Hash === transformed_pair) ? Hash[ transformed_pair ] : nil
  end

  private def bedrooms(css)
    badrooms_and_bathrooms(css, /bed.?room/i)
  end

  private def bathrooms(css)
    badrooms_and_bathrooms(css, /bath.?room/i)
  end

  private def badrooms_and_bathrooms(css, room_type_regex)
    # 1. Check if the node is a pure number.
    # http://stackoverflow.com/a/5661695/3837223
    count = Float(@xml_doc.at(css)&.text) rescue false
    return count.to_i if count

    # 2. Check if the node is a hash of room type and count.
    xml_strings = @xml_doc.css(css).map { |node| node.to_s }
    xml_strings.each do |str|
      return str.scan(/\d+/)[0] if str =~ room_type_regex
    end

    nil
  end

  private def availability(css)
    @xml_doc.at(css)&.text
  end

end
