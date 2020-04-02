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
    resources :users, only: [:update]
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
    resources :credit_cards
    resources :charges
    post '/new_card' => 'charges#new_card', :as => 'new_card'
    get '/products/:id' => 'products#show'
    post '/new_card_from_acct' => 'credit_cards#new_card_from_acct', :as => 'new_card_from_acct'
    put '/requests/renew/request/:id' => 'requests#renew'
    put '/services/renew/service/:id' => 'services#renew'
    get '/requests/toggle_active/:id' => 'requests#toggle_active', :as => 'toggle_active_request'
    get '/services/toggle_active/:id' => 'services#toggle_active', :as => 'toggle_active_service'
  end

  # protect any routes we want to be admin-only level
  authenticated :user, lambda { |u| u.admin? } do
    resources :products
  end

  # goes after /services/new to make sure "new" isn't interpreted as :id
  get '/services/:id' => 'services#show', :as => 'service'
  get '/requests/:id' => 'requests#show', :as => 'request'

  devise_for :users, :controllers => { :registrations => 'registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # mount StripeEvent::Engine, at: '/payments'
  # get SSL cert
  get '/.well-known/acme-challenge/jtRk-WCkcTLpYr1VWom9jFN35KIWUlxXgGRwUUfXGXE' => 'pages#cert1'
  get '/.well-known/acme-challenge/3rFti9PATS2VzhJSF_5w58gEGQL4HJVn_pnugnHS6Lo' => 'pages#cert2'
end