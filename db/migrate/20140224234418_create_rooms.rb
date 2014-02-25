class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.float :price
      t.integer :min_stay
      t.string :room_type
      t.text :amenities
      t.date :deadline
      t.float :depost
      t.boolean :cc_required
      t.integer :min_age
      t.string :room_gender
      t.text :notes
      t.integer :sleeps
      t.float :price_per_person
      t.references :lodging, index: true
      t.references :trip, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
