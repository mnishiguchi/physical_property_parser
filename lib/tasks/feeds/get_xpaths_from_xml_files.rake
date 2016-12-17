require 'nokogiri'

namespace :feeds do
  desc "Get xpaths from xml files in `db/files/`"
  task get_xpaths_from_xml_files: :environment do

    # Get all the example feeds.
    source_dir   = Rails.root.join("db/files/feeds").to_s
    source_files = Dir.glob("#{source_dir}/*.xml")

    output_dir = Rails.root.join("db/files/feeds_processed", "xpaths").to_s

    source_files.each_with_index do |source_file, i|
      puts "Processing #{source_file}"
      file = source_file.sub(source_dir, output_dir).gsub('.xml', '.rb')
      data = all_xpaths(parse_xml(source_file)).join("\n")
      File.write(file, data)
    end

    puts "Done"
  end
end

def parse_xml(xml_file)
  # Read xml files and parse them using Nokogiri.
  # http://www.nokogiri.org/tutorials/parsing_an_html_xml_document.html#from_a_file
  Nokogiri::XML(File.open(xml_file))
end

# Generates an array of all the xpath from a Nokogiri-parsed document.
# Duplicate xpaths will be removed and array indices will be replaced with `[]`.
# http://stackoverflow.com/a/15692699/3837223
def all_xpaths(parsed_doc)
  xpaths = parsed_doc.xpath('//*').map do |node|
    node.path.gsub(/\[\d*\]/, "[]")
  end.uniq
end
