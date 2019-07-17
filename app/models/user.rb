class User < ActiveRecord::Base
	EMAIL_REGEX = /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
	validates :name, :presence => true
	validates :aadhar_num, :presence => true, :uniqueness => true
	validates :contact_num, :presence => true
	validates :email_id, :presence => true, :uniqueness => true
	validates :city, :presence => true
	validates :country, :presence => true

	def return_json
		hash_user_details = {
			:name => self.name,
			:aadhar_num => self.aadhar_num,
			:contact_num => self.contact_num,
			:email_id => self.email_id,
			:city => self.city,
			:country => self.country
		}.with_indifferent_access
		return hash_user_details
	end
end
