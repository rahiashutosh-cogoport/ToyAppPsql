class CreateExternalFreightRates < ActiveRecord::Migration[5.0]
  def change
    create_table :external_freight_rates do |t|

      t.timestamps
    end
  end
end
