class CreateFeedXpaths < ActiveRecord::Migration[5.0]
  def change
    create_table :feed_xpaths do |t|
      t.string :xpath

      t.timestamps
    end
  end
end
