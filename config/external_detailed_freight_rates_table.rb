class ExternalDetailedFreightRatesTable < ActiveRecord::Base
  establish_connection :external_detailed_freight_rates_table
  table_name "customers"
end