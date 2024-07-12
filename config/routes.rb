Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  resource :role, only: :new
  resources :businesses, except: :destroy, param: :hashid
  resources :candidates, except: :destroy, param: :hashid

  # Routes for candidate
  namespace :talent_assessment do
    get 'checkout', to: 'checkout#show'
    get 'test/1/feedback', to: 'test#feedback'
    get 'test/1/intro', to: 'test#intro'
    get 'test/1/questions', to: 'test#questions'
    get 'practice_test/1/intro', to: 'practice_test#intro'
    get 'practice_test/1/questions', to: 'practice_test#questions'
    get 'overview', to: 'overview#show'
    get 'setup', to: 'setup#show'
  end

  namespace :candidate do
    get 'assessments', to: 'assessments#index'
    get 'assessments/1', to: 'assessments#show'
  end

  # Routes for customer
  namespace :customer do
    get 'tests', to: 'tests#index'

    get 'candidates', to: 'candidates#index'
    get 'candidates/1', to: 'candidates#show'

    get 'assessments', to: 'assessments#index'
    get 'assessments/new', to: 'assessments#new'
    get 'assessments/1', to: 'assessments#show'
    get 'assessments/1/candidates/1', to: 'assessments#candidate'

    get 'profile/team', to: 'profile#team'
  end

  get 'preview/1', to: 'preview#show'

  # Routes for general
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
