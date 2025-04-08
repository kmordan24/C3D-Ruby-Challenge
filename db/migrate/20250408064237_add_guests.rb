class AddGuests < ActiveRecord::Migration[7.1]
  def change
    create_table :guests do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.belongs_to :event, null: false, foreign_key: true
      t.timestamps
    end
  end
end
