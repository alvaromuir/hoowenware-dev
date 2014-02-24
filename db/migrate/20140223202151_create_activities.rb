class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :activity_type,  :null => false
      t.string :name,           :null => false, :default => ""
      t.string :link
      t.string :venue
      t.text :address
      t.text :contact
      t.float :price
      t.date :date,             :null => false
      t.time :start_time
      t.time :end_time
      t.text :notes
      t.date :deadline
      t.integer :tickets_available
      t.boolean :deposit_required
      t.boolean :cc_required
      t.integer :min_age
      t.string  :gender
      t.boolean :is_active,     :default => true
      t.boolean :is_approved
      t.integer :approved_by

      t.references :user, index: true
      t.references :trip, index: true

      t.timestamps
    end
  end
end
