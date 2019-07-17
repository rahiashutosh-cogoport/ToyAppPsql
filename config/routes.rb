Rails.application.routes.draw do
  post '/rates', to: 'rates#index'
  get '/get_load_rates', to: 'rates#get_load_rates'
  get '/rates', to: 'rates#index'
  get '/index', to: 'index#index'
  get '/signup', to: 'signup#signup'
  post '/commit_user', to: 'signup#commit_user'
  get '/login', to: 'login#login'
  post '/login', to: 'login#login'
  get '/login_user', to: 'login#login_user'
  get '/logout', to: 'login#logout'
  get '/logged_in', to: 'login#logged_in'
  get '/current_user', to: 'login#current_user'
  get '/get_location_suggestions', to: 'rates#generate_location_suggestions'
  get '/get_rates', to: 'rates#get_rates'
  get '/get_company_name', to: 'rates#get_shipping_line_name'
  get '/verify_email', to: 'signup#verify_email'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
