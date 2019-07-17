class CreateLocations < ActiveRecord::Migration[5.0]
  def change
    create_table :locations do |t|
      t.text :port_id
      t.string :display_name
      t.integer :postal_code
      t.text :loc
      t.string :country_code
      t.string :name

      t.timestamps
    end
  end
end
