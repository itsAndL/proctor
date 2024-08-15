Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  devise_for :users, path: '/auth', controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations'
  }

  resource :role, only: :new
  resources :businesses, only: %i[new create edit update], param: :hashid
  resources :candidates, only: %i[new create edit update], param: :hashid
  resources :test_library, only: %i[index show], param: :hashid do
    resources :preview_questions, only: %i[show], param: :hashid
  end
  resources :assessments, only: %i[index new create edit update], param: :hashid do
    member do
      patch 'archive'
      patch 'unarchive'
      get 'choose_tests'
      patch 'update_tests'
      get 'add_questions'
      patch 'update_questions'
      get 'finalize'
      patch 'finish'
    end

    resources :custom_questions, only: [], param: :hashid do
      resources :assessment_custom_questions, only: %i[create destroy], param: :hashid do
        member do
          patch 'change_position'
        end
      end
    end

    resources :tests, only: [], param: :hashid do
      resources :assessment_tests, only: %i[destroy], param: :hashid do
        member do
          patch 'change_position'
        end
      end
    end
  end
  resources :custom_question_library, only: %i[index], param: :hashid

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
    get 'candidates', to: 'candidates#index'
    get 'candidates/1', to: 'candidates#show'

    get 'assessments/1', to: 'assessments#show'
    get 'assessments/1/candidates/1', to: 'assessments#candidate'

    get 'profile/team', to: 'profile#team'
  end

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
