Rails.application.routes.draw do
  namespace :candidate do
    get 'assessments', to: 'assessments#index'
    get 'assessments/1', to: 'assessments#show'

    get 'profile', to: 'profile#index'
  end
  get 'register/candidate', to: 'register#candidate'

  namespace :customer do
    get 'candidates', to: 'candidates#index'
    get 'candidates/1', to: 'candidates#show'

    get 'assessments', to: 'assessments#index'
    get 'assessments/new', to: 'assessments#new'
    get 'assessments/1', to: 'assessments#show'
    get 'assessments/1/candidates/1', to: 'assessments#candidate'

    get 'profile', to: 'profile#profile'
    get 'profile/team', to: 'profile#team'
  end
  get 'register/customer', to: 'register#customer'

  get 'login', to: 'login#index'
  get 'contact', to: 'contact#index'
  get 'about', to: 'about#index'
  get 'home', to: 'home#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
