class CreateLodgings < ActiveRecord::Migration
  def change
    create_table :lodgings do |t|
      t.string :lodging_type
      t.string :name,  :null => false, :default => ""
      t.string :link
      t.text :contact
      t.date :checkin_date,  :null => false
      t.time :checkin_time
      t.date :checkout_date,  :null => false
      t.text :address
      t.float :star_rating
      t.string :reviews_link
      t.text :notes
      t.string :cover_photo
      t.boolean :is_active, :default => true
      t.references :user, index: true
      t.references :trip, index: true

      t.timestamps
    end
  end
end
