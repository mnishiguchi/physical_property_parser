require "webmock"

namespace :db do
  desc "Import feed data from source url"
  task :import_feeds => :environment do

    include WebMock::API
    WebMock.enable!

    # Get file paths.
    file_paths = Dir.glob(Rails.root.join("db/files/feeds", "*.xml"))

    # Associate those file paths with fake urls.
    file_paths.each_with_index do |file_path, i|
      url = "http://www.example.com/feed-source-#{i}"
      stub_request(:get, url).to_return(body: File.read(file_path))
    end

    puts "Importing Feeds"
    FeedSource.all.each do |feed_source|
      print "."
      feed_source.import_feed
    end
    puts ""
    WebMock.disable!

    puts "Feed.count: #{Feed.count}"
    puts "FeedXpath.count: #{FeedXpath.count}"
  end
end
