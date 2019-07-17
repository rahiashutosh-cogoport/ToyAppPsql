class ExternalFreightRate < ActiveRecord::Base
	establish_connection "external_detailed_freight_rates_table"
  	self.table_name = "rate_detailed_fcl_freight_charges"
end