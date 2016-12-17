module FieldPathMappingsHelper

  # A wrapper of the simpleform's select tag that has options of xpaths.
  # It finds and shows an example value of the selected xpath.
  # NOTE: Although xpaths are saved in database, we use css-paths here because
  # css-paths are easier on the eyes.
  # https://github.com/plataformatec/simple_form#collections
  def field_path_mapping_select_tag(f, name)
    example_data = @field_path_mapping.example_data_for_field(name)

    f.input name, collection: @field_path_mapping.all_css_paths,
                  selected:   @field_path_mapping.css_path(name),
                  hint:       pretty_json(example_data),
                  include_blank: "(select if none)"
  end

  def pretty_example_json(xpath)
    example_data = @field_path_mapping.example_data_for_xpath(xpath)
    pretty_json(example_data)
  end

  def pretty_json(xml)
    return "" if xml.blank?
    JSON.pretty_generate(Hash.from_xml(xml))
  end
end
