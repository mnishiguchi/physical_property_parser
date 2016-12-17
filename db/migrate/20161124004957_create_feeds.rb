class CreateFeeds < ActiveRecord::Migration[5.0]
  def change
    create_table :feeds do |t|
      t.text :raw_xml,               null: false
      t.string :xpaths, array: true, null: false
      t.references :feed_source, foreign_key: true

      t.timestamps
    end
  end
end
