class ExternalDetailedFreightRates < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :external_detailed_freight_rates_table
end