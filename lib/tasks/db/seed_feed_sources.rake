require "webmock"

namespace :db do
  desc "Create fake feed sources in database"
  task :seed_feed_sources => :environment do

    include WebMock::API
    WebMock.enable!

    # Get all the example feeds.
    file_paths = Dir.glob(Rails.root.join("db/files/feeds", "*.xml"))

    # Associate those file paths with fake urls and create FeedSources.
    file_paths.each_with_index do |file_path, i|
      url = "http://www.example.com/feed-source-#{i}"
      stub_request(:get, url).to_return(body: File.read(file_path))

      puts "Creating FeedSource for #{url}"
      FeedSource.for_url(url)
    end

    WebMock.disable!
  end
end
