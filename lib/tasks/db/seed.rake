namespace :db do
  desc "Seed database with fake data"
  task :seed => :environment do

    if Rails.env.development?
      Rake::Task["db:migrate:reset"].invoke
    end

    invoke_tasks [
      "db:seed_feed_sources",
      "db:import_feeds",
      # "db:convert_feeds_to_properties",
    ]
  end
end

def invoke_tasks(rake_tasks)
  rake_tasks.each { |rake_task| Rake::Task[rake_task].invoke }
end
