Rails.application.routes.draw do
  get 'candidates', to: 'candidates#index'
  get 'assessments', to: 'assessments#index'
  get 'contact', to: 'contact#index'
  get 'about', to: 'about#index'
  get 'login', to: 'login#index'
  get 'register', to: 'register#index'
  get 'home', to: 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
