class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :booked_by_email
      t.string :booked_by_name
      t.string :description
      t.date :starts_at
      t.date :ends_at
      t.timestamps
    end
  end
end
