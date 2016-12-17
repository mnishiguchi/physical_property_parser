class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.string :marketing_name
      t.string :website
      t.text :description
      t.string :contact_email
      t.string :contact_phone
      t.string :street
      t.string :city
      t.string :state
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.json :pet_dog
      t.json :pet_cat
      t.json :amenities
      t.references :feed, index: true

      t.timestamps
    end
  end
end
