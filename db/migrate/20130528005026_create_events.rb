class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :booked_by_email
      t.string :booked_by_name
      t.string :description
      t.date :date
      t.timestamps
    end
  end
end
