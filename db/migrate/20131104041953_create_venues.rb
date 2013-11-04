class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name, :foreign_key, :phone, :website, :category, :icon
      t.text :address, :notes
      t.integer :user_id, :leg_id
      t.timestamps
    end

    add_column :venues, :location, :point, :geographic => true
  end
end
