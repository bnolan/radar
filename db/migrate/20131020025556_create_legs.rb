class CreateLegs < ActiveRecord::Migration
  def change
    create_table :legs do |t|
      t.string :city_path
      t.float :latitude, :longitude
      t.date :arrival
      t.integer :user_id, :trip_id

      t.timestamps
    end
  end
end
