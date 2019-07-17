class Location < ActiveRecord::Base
	def self.get_locations_suggestions(params)
    alphabet = 'A'
    unless params[:alphabet].blank?
      alphabet = params[:alphabet]
    end

    data_to_fetch = [:country_code,:display_name, :name]
    escaped = Regexp.escape(alphabet).to_s
    pattern = "%" + alphabet.to_s.downcase + "%"
    locations = Location.where("lower(display_name) like ?", pattern)
    response = []
    locations.each do |location|
      location = location.as_json
      response << location
    end

    total_page = response.count
    return response,total_page
  end
end
