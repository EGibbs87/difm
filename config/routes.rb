Rails.application.routes.draw do
  root :to => 'pages#home'

  get '/about' => 'pages#about', :as => 'about'
  get '/services' => 'services#index', :as => 'services'
  get '/requests' => 'requests#index', :as => 'requests'
  get '/search_services' => 'services#search', :as => 'search_services'
  get '/search_requests' => 'requests#search', :as => 'search_requests'
  post '/search_listings' => 'pages#search', :as => 'search_listings'
  get '/users' => 'users#users', :as => 'users'
  get '/users/:user_id/reviews' => 'users#reviews', :as => 'reviews'

  authenticated :user do
    get '/services/new' => 'services#new', :as => 'new_service'
    post '/services/new' => 'services#create', :as => 'create_service'
    get '/services/:id/edit' => 'services#edit', :as => 'edit_service'  
    put '/services/:id' => 'services#update'
    delete '/services/:id' => 'services#destroy', :as => 'destroy_service'
    get '/requests/new' => 'requests#new', :as => 'new_request'
    post '/requests/new' => 'requests#create', :as => 'create_request'
    get '/requests/:id/edit' => 'requests#edit', :as => 'edit_request'  
    put '/requests/:id' => 'requests#update'
    delete '/requests/:id' => 'requests#destroy', :as => 'destroy_request'
    get '/dashboard' => 'pages#dashboard'
    get '/users/:user_id/reviews/new_review' => 'users#new_review', :as => 'new_review'
    get '/users/:user_id/reviews/edit_review' => 'users#edit_review', :as => 'edit_review'
    post '/users/:user_id/reviews/new_review' => 'users#create_review', :as => 'create_review'
    put '/users/:user_id/reviews/edit_review' => 'users#update_review', :as => 'update_review'
    delete '/users/reviews/:id' => 'users#destroy_review', :as => 'destroy_review'
    resources :products
    resources :credit_cards
    resources :charges
  end

  # goes after /services/new to make sure "new" isn't interpreted as :id
  get '/services/:id' => 'services#show', :as => 'service'
  get '/requests/:id' => 'requests#show', :as => 'request'

  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  mount StripeEvent::Engine, at: '/payments'
end