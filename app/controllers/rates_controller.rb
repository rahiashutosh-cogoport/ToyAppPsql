class RatesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  	headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Allow-Credentials'] = 'true'
  	@result = {}
  	@destination_name = "--"
  	@origin_name = "--"
  	@user_logged_in = nil
  	@total_loads = 0
  	@total_pages = 0
  	if request.post?  		
	  	result_hash = get_rates(params)
	  	origin_and_destination_hash = get_origin_and_destination_names(params)
	  	@result = result_hash
	  	count=0
	  	@result.each do |res|
	  		count=count+1
	  	end
	  	@total_loads = count
	  	@total_pages = @total_loads/10 + 1	  	
	  	@origin_name = origin_and_destination_hash[:origin]
	  	@destination_name = origin_and_destination_hash[:destination]
	  	@user_logged_in = User.where(:aadhar_num => $redis[cookies[:user_token]])[0]
	  	render :json => {
	  		:numLoads => @total_loads,
	  		:numPages => @total_pages,
	  		:loads => @result,
	  		:origin_name => @origin_name,
	  		:destination_name => @destination_name,
	  		:user => @user_logged_in
	  	}
  	else
  		token = cookies[:user_token]
  		puts 'THE TOKEN IS: ' + token.to_s  
  		puts 'AADHAR: ' + $redis.get(token).to_s
  		@user_logged_in = User.where(:aadhar_num => $redis[cookies[:user_token]])[0]
  		aadhar = $redis.get(token)  			
  		if token.present? && !($redis.get(token).present?)
  			# render 'session_ended'
  			render :json => {
  				:status => :ok,
  				:message => 'Session Ended'
  			}.to_json
  		elsif !token.present? || !($redis.get(token).present?)
  			# render 'unauthorized_access'
  			render :json => {
  				:status => :ok,
  				:message => 'Unauthorized Access'
  			}.to_json
  		else
  			# render 'index'
  			render :json => {
  				:status => :ok,
  				:message => 'Authenticated User'
  			}.to_json
  		end
  	end  	
  end

  def get_load_rates  
  	headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Allow-Credentials'] = 'true'	
  	result_hash = get_rates(params)
 #  	result_hash.each do |r|
	# 	a=Organization.where(:organization_id => r['shipping_line_id'])[0].business_name
	# end	
	origin_and_destination_hash = get_origin_and_destination_names(params)
	@result = result_hash
	count=0
	company_names = []
	@result.each do |res|
	  	count=count+1	  	
	  	business_name = Organization.where(:organization_id => res['shipping_line_id'])[0].business_name
	  	company_names.push(business_name)
	end
	@total_loads = count
	@total_pages = @total_loads/10 + 1	  	
	@origin_name = origin_and_destination_hash[:origin]
	@destination_name = origin_and_destination_hash[:destination]
	@user_logged_in = User.where(:aadhar_num => $redis[cookies[:user_token]])[0]
	puts "RESULT: " + @result.to_s
	render :json => {
	  	:numLoads => @total_loads,
	  	:numPages => @total_pages,
	  	:loads => @result,
	  	:origin_name => @origin_name,
	  	:destination_name => @destination_name,
	  	:user => @user_logged_in,
	  	:company_names => company_names
	}
  end

  def get_shipping_line_name
  	headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Allow-Credentials'] = 'true'
    org_name = Organization.where(:organization_id => params[:shipping_line_id])[0].business_name
    render :json => {
    	:business_name => org_name
    }
  end

  def search
  	a=User.where(:aadhar_num => params[:aadhar_number])
  	hash_user_details = {
  		:name => a.name,
  		:aadhar_num => a.aadhar_num
  	}
  	return hash_user_details
  end

  def signup
  	a=User.new(:name => params[:name],
  		:aadhar_num => params[:aadhar])
  	a.save
  end

  def generate_location_suggestions
  	headers['Access-Control-Allow-Origin'] = 'http://localhost:3001'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Allow-Credentials'] = 'true'    
  	arr = Location.get_locations_suggestions(params)
  	puts "PARAMS IN GET LOCATION SUGGESTION RECEIVED: " + params.to_s
  	render :json => { 
        :status => :ok, 
        :matches => arr[0],
        :num_matches => arr[1]
    }.to_json
  end

  def get_rates(params)
  	origin_port = Location.where(:display_name => params[:originportname])[0]
  	puts "FOUND ORIGIN: " + origin_port.to_s
  	dest_port = Location.where(:display_name => params[:destportname])[0] 
  	puts "FOUND DESTINATION: " + dest_port.to_s 	
  	conn = ActiveRecord::Base.establish_connection(
	  :adapter  => "postgresql",
	  :host     => "pricing-readtestdb.cogoport.com",
	  :port => 5432,
	  :username => "postgres",
	  :password => "cogoportreadtestdb",
	  :database => "cogoport_rate_pg"
	).connection
	res = conn.execute("SELECT * FROM rate_detailed_fcl_freight_charges WHERE \"origin_port_id\" = '" + origin_port.port_id.to_s + "' AND \"destination_port_id\" = '" + dest_port.port_id.to_s + "' AND \"commodity\" = '" + params[:commodity].to_s + "' AND \"container_type\" = '" + params[:conttype] + "' AND \"container_size\" = '" + params[:contsize].to_s + "' ORDER BY \"total_price\" ASC")	
	# res = conn.execute("SELECT AVG(\"total_price\") FROM rate_detailed_fcl_freight_charges WHERE \"origin_port_id\" = '" + origin_port.port_id.to_s + "' AND \"destination_port_id\" = '" + dest_port.port_id.to_s + "' AND \"commodity\" = '" + params[:commodity].to_s + "' AND \"container_type\" = '" + params[:conttype] + "' AND \"container_size\" = '" + params[:contsize].to_s + "' GROUP BY \"shipping_line_id\"")		
	conn.close
	conn_new = ActiveRecord::Base.establish_connection(
	  :adapter => "postgresql",
	  :database => "toy-app-psql_development",
	  :username => "toy-app-psql",
	  :password => 1234,
	  :host => "localhost",
	  :port => 5432
 	).connection
  	return res
  end

  def get_origin_and_destination_names(params)
  	origin = params[:originportname]
  	destination = params[:destportname]
  	return {
  		:origin => origin,
  		:destination => destination
  	}
  end
end
