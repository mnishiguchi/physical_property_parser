class FloorplanParser

  TRUE_REGEX = /^(true|t|yes|y|1)$/i

  def initialize(floorplan_node)
    @floorplan_node = floorplan_node
  end

  # Relative xpaths to Floorplan node.
  @@attr_to_xpaths_mapping = {
    name:           [ "Name" ],
    square_feet:    [ "SquareFeet" ],
    market_rent:    [ "MarketRent" ],
    effective_rent: [ 'EffectiveRent' ],
    bedrooms:       [ "Room" ],
    bathrooms:      [ "Room" ],
    availability:   [ "" ],
  }.with_indifferent_access

  def xpaths_for_attr_name(attr_name)
    @@attr_to_xpaths_mapping[attr_name].map(&:presence).compact
  end

  def attr_names
    @@attr_to_xpaths_mapping.keys
  end


  # ---
  # Parsers corresponding to all the individual attribute names.
  # + The method name must match the attribute name.
  # + Returns a value for the attribute.
  # ---


  def name
    get_text_for_attr_name(__callee__)
  end

  def square_feet
    @floorplan_node.at(*xpaths_for_attr_name(__callee__))&.to_s.scan(/\d+/)[0]
  end

  def market_rent
    parse_rent(*xpaths_for_attr_name(__callee__))
  end

  def effective_rent
    parse_rent(*xpaths_for_attr_name(__callee__))
  end

  def bedrooms
    parse_rooms(__callee__, /bed.?room/i)
  end

  def bathrooms
    parse_rooms(__callee__, /bath.?room/i)
  end

  def availability
    get_text_for_attr_name(__callee__)
  end

  private def parse_rent(xpath)

    # An array of key-value pairs with downcase keys.
    transformed_pair = @floorplan_node.at(xpath)&.to_h&.map { |k, v| [ k.downcase, v ] }

    return if !transformed_pair.is_a?(Array) && transformed_pair.blank?
    Hash[ transformed_pair ]
  end

  private def parse_rooms(attr_name, room_type_regex)
    css = xpaths_for_attr_name(attr_name)
    # 1. Check if the node is a pure number.
    # http://stackoverflow.com/a/5661695/3837223
    count = Float(@floorplan_node.at(*css)&.text) rescue false
    return count.to_i if count

    # 2. Check if the node is a hash of room type and count.
    xml_strings = @floorplan_node.search(*css).map { |node| node.to_s }
    xml_strings.each do |str|
      return str.scan(/\d+/)[0] if str =~ room_type_regex
    end

    nil
  end

  private def get_text_for_attr_name(attr_name)
    @floorplan_node.at(*xpaths_for_attr_name(attr_name))&.text
  end
end
