class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.text :notes
      t.date :start, :finish
      t.integer :user_id
      
      t.timestamps
    end
  end
end
