class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name, :null => false
      t.bigint :aadhar_num, :null => false
      t.bigint :contact_num, :null => false
      t.string :email_id, :null => false
      t.string :city, :null => false
      t.string :country, :null => false

      t.timestamps
    end
  end
end
