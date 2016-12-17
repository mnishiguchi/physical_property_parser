namespace :db do
  desc "Convert feeds to properties"
  task :convert_feeds_to_properties => :environment do

    puts "Converting feeds to properties"

    Feed.all.map do |feed|
      feed.create_properties
    end

    puts "Property.count:  #{Property.count}"
    puts "Floorplan.count: #{Floorplan.count}"
  end
end
