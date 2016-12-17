require 'open-uri'

namespace :feeds do
  desc "Convert xml files to ruby`"
  task convert_xml_to_rb: :environment do

    # Get all the example feeds.
    source_dir   = Rails.root.join("db", "files", "feeds").to_s
    source_files = Dir.glob("#{source_dir}/*.xml")

    output_dir = Rails.root.join("db/files/feeds_processed", "rb").to_s

    source_files.each do |source_file|
      puts "Processing #{source_file}"
      feed = open(source_file) { |io| io.read }
      hash = Hash.from_xml(feed)
      file = source_file.sub(source_dir, output_dir).gsub('.xml', '.rb')
      File.write(file, hash)
    end
    
    puts "Done"
  end
end
