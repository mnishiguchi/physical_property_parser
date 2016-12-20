class CreatePropertyXpaths < ActiveRecord::Migration[5.0]
  def change
    create_table :property_xpaths do |t|
      t.string :marketing_name, array: true, default: []
      t.string :website, array: true, default: []
      t.string :description, array: true, default: []
      t.string :contact_phone, array: true, default: []
      t.string :contact_email, array: true, default: []
      t.string :street, array: true, default: []
      t.string :city, array: true, default: []
      t.string :zip, array: true, default: []
      t.string :latitude, array: true, default: []
      t.string :longitude, array: true, default: []

      t.timestamps
    end
  end
end
