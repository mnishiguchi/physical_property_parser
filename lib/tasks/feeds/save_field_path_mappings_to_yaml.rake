require 'yaml'

namespace :feeds do
  desc "Save field-path mapping from database to yaml files"
  task save_field_path_mappings_to_yaml: :environment do

    output_dir = Rails.root.join("db/files/feeds_processed", "field_path_mappings")

    FieldPathMapping.all.each_with_index do |mapping, i|
      url = mapping.feed_source.url
      puts "Processiong #{url}"
      output_file = "#{output_dir}/field_path_mapping_#{url.gsub('/', '-')}_#{Date.today}.yaml"
      File.write(output_file, mapping.field_attributes.to_yaml)
    end

    puts "Done"
  end
end
