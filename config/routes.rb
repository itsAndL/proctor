Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    namespace :api do
      resources :monitoring, only: [:update], param: :hashid
    end

    devise_for :users, path: '/auth', skip: %i[registrations], controllers: {
      confirmations: 'users/confirmations',
      passwords: 'users/passwords',
      sessions: 'users/sessions',
      registrations: 'users/registrations'
    }

    scope '/auth' do
      devise_scope :user do
        # Business routes
        get 'business/sign_up', to: 'business/registrations#new', as: :new_business_registration
        post 'business', to: 'business/registrations#create', as: :business_registration

        # Candidate routes
        get 'candidate/sign_up', to: 'candidate/registrations#new', as: :new_candidate_registration
        post 'candidate', to: 'candidate/registrations#create', as: :candidate_registration

        # Common routes
        get 'edit', to: 'users/registrations#edit', as: :edit_user_registration
        put 'update', to: 'users/registrations#update', as: :user_registration
      end
    end

    resource :role, only: :new
    resources :businesses, only: %i[new create edit update], param: :hashid
    resources :candidates, only: %i[new create edit update], param: :hashid
    resources :test_library, only: %i[index show], param: :hashid do
      resources :preview_questions, only: %i[show], param: :hashid
    end
    resources :custom_question_library, only: %i[index], param: :hashid
    resources :custom_question_responses, only: %i[edit update], param: :hashid do
      member do
        get :download
      end
    end
    resources :assessment_participations, only: [:destroy], param: :hashid do
      member do
        get :delete_confirmation
        post :send_reminder
        get :report
        patch :rate
      end
    end

    get 'i/:token', to: 'candidate/assessment_participations#invitation', as: :invitation
    get 'a/:public_link_token', to: 'invite_candidates#public_link', as: :public_assessment

    resources :assessments, only: %i[index show new create edit update], param: :hashid do
      member do
        patch :archive
        patch :unarchive
        get :require_edit
        get :choose_tests
        patch :update_tests
        get :add_questions
        patch :update_questions
        get :finalize
        patch :finish
        get :rename
        patch :update_title
        get :share, to: 'invite_candidates#share'
        patch :activate_public_link, to: 'invite_candidates#activate_public_link'
        patch :deactivate_public_link, to: 'invite_candidates#deactivate_public_link'
        post :invite_me, to: 'invite_candidates#invite_me'
        get :invite, to: 'invite_candidates#invite'
        post :post_invite, to: 'invite_candidates#post_invite'
        post :check_candidate, to: 'invite_candidates#check_candidate'
        get :bulk_invite, to: 'invite_candidates#bulk_invite'
        get :bulk_invite_template, to: 'invite_candidates#bulk_invite_template'
        post :bulk_invite_upload, to: 'invite_candidates#bulk_invite_upload'
      end

      resources :custom_questions, only: [], param: :hashid do
        resources :assessment_custom_questions, only: %i[create destroy], param: :hashid do
          member do
            patch :change_position
          end
        end
      end

      resources :tests, only: [], param: :hashid do
        resources :assessment_tests, only: %i[destroy], param: :hashid do
          member do
            patch :change_position
          end
        end
      end
    end

    namespace :candidate do
      resources :tests, only: %i[index show], path: '/tests', param: :hashid do
        member do
          get :feedback
          get 'practice_questions/:question_id', to: 'tests#practice_questions', as: :practice_questions
          get :questions
          get :intro
          get :start
          post :save_answer
        end
      end
      resources :custom_questions, only: %i[index show], path: '/custom-questions', param: :hashid do
        member do
          get :questions
          get :start
          post :save_answer
        end
      end
      resources :assessment_participations, only: %i[index show], path: '/assessments', param: :hashid do
        member do
          get :overview
          get :setup
          get :checkout
        end
      end
    end

    # Routes for customer
    namespace :customer do
      resources :candidates, only: %i[index show], param: :hashid

      get 'profile/team', to: 'profile#team'
    end

    # Routes for general
    get 'contact', to: 'contact#index'
    get 'about', to: 'about#index'
    get 'home', to: 'home#index'

    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get 'up' => 'rails/health#show', as: :rails_health_check

    # Defines the root path route ("/")
    root 'home#index'
  end
end
