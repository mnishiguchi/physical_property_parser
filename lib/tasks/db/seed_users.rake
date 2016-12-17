namespace :db do
  desc "Create fake users in database"
  task :seed_users => :environment do

    # ---
    # General users
    # ---


    puts "Creating User"
    user = User.create!(
      name: "Example user"
    )
    Identity.create!(
      email:        "user@example.com",
      password:     "password",
      confirmed_at: Time.zone.now,
      user:         user
    )


    # ---
    # General backend users
    # ---


    puts "Creating Admin"
    admin = Admin.create!(
      name: "Example admin"
    )
    Identity.create!(
      email:        "admin@example.com",
      password:     "password",
      confirmed_at: Time.zone.now,
      backend_user: admin
    )


    puts "Creating AccountExecutive"
    account_executive = AccountExecutive.create!(
      name: "Example account_executive"
    )
    Identity.create!(
      email:        "account_executive@example.com",
      password:     "password",
      confirmed_at: Time.zone.now,
      backend_user: account_executive
    )


    # Create a registered management_client that belongs to the account_executive.
    puts "Creating ManagementClient"
    management_client = account_executive.management_clients.create!(
      name: "Example management_client"
    )
    Identity.create!(
      email:        "management_client@example.com",
      password:     "password",
      confirmed_at: Time.zone.now,
      backend_user: management_client
    )


    # Create a registered property_client that belongs to the account_executive.
    property_client = account_executive.property_clients.create!(
      name: "Example property_client"
    )
    Identity.create!(
      email:        "property_client@example.com",
      password:     "password",
      confirmed_at: Time.zone.now,
      backend_user: property_client
    )
  end
end
