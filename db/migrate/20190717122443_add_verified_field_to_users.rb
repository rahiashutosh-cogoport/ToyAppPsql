class AddVerifiedFieldToUsers < ActiveRecord::Migration[5.0]
  change_table :users do |t|
  	t.boolean :verified, :boolean, default: false
  end
end
