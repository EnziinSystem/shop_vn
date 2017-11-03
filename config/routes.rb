Rails.application.routes.draw do

  resources :order_items, only: [:create, :destroy]
  resources :orders, only: [:create]
  resources :carts

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

  post '/order_items/up/:id' => 'order_items#increment_quantity'

  post '/order_items/down/:id' => 'order_items#decrement_quantity'

  post '/carts/send_confirm_order' => 'carts#send_confirm_order', as: :cart_send_confirm_order

  get '/cart-confirm-auth' => 'carts#confirm_auth', as: :confirm_auth

  get '/cart-confirm-email' => 'carts#confirm_email'

  get '/orders' => 'orders#show', as: :show_order

  get '/express_checkout/:id' => 'payments#paypal_express', as: :paypal_express_checkout

  get '/complete/:id' => 'payments#paypal_complete', as: :complete

  get '/orders/list', to: 'orders#list', as: :my_orders

  match '/payment_2co' => 'payments#payment_2_checkout', via: [:get, :post]

  post '/orders/payments/bao-kim/submit-cart' => 'orders#bao_kim_submit_cart', as: :bao_kim_submit_cart

  get '/orders/payments/bao-kim/success-cart' => 'payments#bao_kim_success_cart'

  post '/orders/payments/bao-kim/bpn' => 'payments#bao_kim_bpn_listener'

  get '/orders/history' => 'orders#history', as: :orders_history

  get '/introduction/:id' => 'pages#introduction'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
