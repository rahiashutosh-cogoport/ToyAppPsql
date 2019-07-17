class CreateOrganizations < ActiveRecord::Migration[5.0]
  def change
    create_table :organizations do |t|
      t.text :organization_id
      t.string :business_name
      t.string :description
      t.text :city_id
      t.text :country_id
      t.text :office_city_id

      t.timestamps
    end
  end
end
