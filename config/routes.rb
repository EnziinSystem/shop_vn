Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :edit => 'profile', :confirmation => 'confirmations'},
             :controllers => {:omniauth_callbacks => 'omniauth_callbacks', registrations: 'registrations', sessions: 'users/sessions'}

  resources :users do
    member do
      post :enable_multi_factor_authentication, to: 'users/multi_factor_authentication#verify_enable'
      post :disable_multi_factor_authentication, to: 'users/multi_factor_authentication#verify_disabled'
    end
  end

  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  concern :paging_category do
    get '(/:id/page/:page)', :action => :show, :on => :collection, :as => ''
  end

  resources :categories, :concerns => :paging_category do
    resources :products
  end

  resources :products, :concerns => :paginatable

  get 'pages/home'

  get 'pages/about'

  root to: 'pages#home', as: :root

  get '/check-user' => 'users#check_user'

  post '/products/search' => 'products#search', as: :products_search

  post '/products/sort/price-up' => 'products#price_up', as: :products_sort_up

  post '/products/sort/price-down' => 'products#price_down', as: :products_sort_down

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
