class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.string :title,      :null => false
      t.string :poll_type,  :null => false
      t.date :start_date
      t.date :end_date
      t.string :location
      t.text :generic_question
      t.text :notes
      t.date :expires
      t.boolean :is_active, :default => true
      t.references :trip,   :index => true
      t.references :user,   :index => true

      t.timestamps
    end
  end
end
