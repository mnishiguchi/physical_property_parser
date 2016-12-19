class PropertyParser

  TRUE_REGEX = /^(true|t|yes|y|1)$/i

  def initialize(property_node)
    @property_node = property_node
  end

  @@attr_to_xpath_mapping = {
    marketing_name: "./Identification/MarketingName",
    website:        "./Identification/WebSite",
    description:    "./Information/LongDescription",
    contact_phone:  "./Identification/Phone/Number",
    contact_email:  "./Identification/Email",
    street:         "./Identification/Address/Address1",
    city:           "./Identification/Address/City",
    state:          "./Identification/Address/State",
    zip:            "./Identification/Address/Zip",
    latitude:       ".//Latitude",
    longitude:      ".//Longitude",
    # file_floorplan: '',
    # file_property: "./File",
    # amenities: "./Amenities",
    # amenities_community: "./Amenities/Community",
    # amenities_floorplan: "./Amenities/Floorplan",
    # pet_dog: "./Policy/Pet",
    # pet_cat: "./Policy/Pet",
  }.with_indifferent_access

  def xpath_for_attr_name(attr_name)
    @@attr_to_xpath_mapping[attr_name]
  end


  # ---
  # Parsers corresponding to all the individual attribute names.
  # + The method name must match the attribute name.
  # + Takes in a css path.
  # + Returns a value for the attribute.
  # ---

  def marketing_name
    @property_node.at(xpath_for_attr_name("marketing_name"))&.text
  end

  def website
    @property_node.at(xpath_for_attr_name("website"))&.text
  end

  def description
    @property_node.at(xpath_for_attr_name("description"))&.text
  end

  def contact_phone
    @property_node.at(xpath_for_attr_name("contact_phone"))&.text
  end

  def contact_email
    @property_node.at(xpath_for_attr_name("contact_email"))&.text
  end

  def street
    @property_node.at(xpath_for_attr_name("street"))&.text
  end

  def city
    @property_node.at(xpath_for_attr_name("city"))&.text
  end

  def state
    @property_node.at(xpath_for_attr_name("state"))&.text
  end

  def zip
    @property_node.at(xpath_for_attr_name("zip"))&.text
  end

  def amenities
    # Amenity hashes
    amenity_hashes = @property_node.search(xpath_for_attr_name("amenities")).map do |node|
      Hash.from_xml(node.to_s)[xpath_for_attr_name("amenities")]
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

  def latitude
    text = @property_node.at(xpath_for_attr_name("latitude"))&.text
    parse_float_string(text)
  end

  def longitude
    text = @property_node.at(xpath_for_attr_name("longitude"))&.text
    parse_float_string(text)
  end

  def parse_float_string(text)
    return nil unless text

    transformed = text&.gsub(/[^0-9\.\-]/,'')&.to_f
    (transformed.blank? || transformed == 0.0) ? text : transformed
  end

  def parse_int_string(text)
    parse_float_string(text)&.to_i
  end

  def pet_cat
    parse_pet_string(xpath_for_attr_name("pet_cat"), /cat/i)
  end

  def pet_dog
    parse_pet_string(xpath_for_attr_name("pet_dog"), /dog/i)
  end

  def parse_pet_string(xpath, pet_type_regex)
    # 1. Check the text node.
    text = @property_node.at(xpath)&.text
    return text if text =~ pet_type_regex

    # 2. Check the children.
    hashes = @property_node.search(xpath).map { |node| node.to_h }
    hashes.each do |hash|
      return hash if hash.to_s =~ pet_type_regex
    end

    nil
  end
end
