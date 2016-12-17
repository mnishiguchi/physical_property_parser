namespace :db do
  desc "Create fake field-path mappings in database"
  task :seed_field_path_mappings => :environment do

    # Get all the `field_path_mappings` files.
    source_dir = Rails.root.join("db/files/feeds_processed", "field_path_mappings").to_s
    source_files = Dir.glob("#{source_dir}/*.yaml")

    FieldPathMapping.all.each do |mapping|
      url = mapping.feed_source.url
      puts "Seeding field-path mapping data for #{url}"

      # Find a file that matches the feed source url.
      source_file = source_files.select { |f| f =~ /#{url.gsub('/', '-')}/ }[0]

      # If the file was found, read that file and update the field_path_mapping.
      if source_file
        attributes = YAML.load_file(source_file)
        FeedSource.for_url(url).field_path_mapping.update_attributes(attributes)
      end
    end
  end
end
