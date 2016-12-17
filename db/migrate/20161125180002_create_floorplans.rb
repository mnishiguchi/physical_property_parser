class CreateFloorplans < ActiveRecord::Migration[5.0]
  def change
    create_table :floorplans do |t|
      t.string :name
      t.json :square_feet
      t.json :market_rent
      t.json :effective_rent
      t.integer :bedrooms
      t.integer :bathrooms
      t.integer :availability
      t.references :property, index: true

      t.timestamps
    end
  end
end
