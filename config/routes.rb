Rails.application.routes.draw do

  devise_for :users, :path => '', :path_names => {:sign_in => 'login', :sign_out => 'logout', :edit => 'profile', :confirmation => 'confirm/:confirmation_token'},
             :controllers => {:omniauth_callbacks => 'omniauth_callbacks', registrations: 'registrations'}

  resources :users

  resources :categories do
    resources :products
  end

  resources :products
  
  get 'pages/home'

  get 'pages/about'

  root to: 'pages#home', as: :root

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
