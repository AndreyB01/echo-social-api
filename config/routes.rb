require "sidekiq/web"

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount ActionCable.server => "/cable"
  mount Sidekiq::Web => "/sidekiq"
  mount LetterOpenerWeb::Engine, at: "/letters" if Rails.env.development?

  get "/healthz", to: "health#index"

  namespace :api do
    namespace :v1 do
      get "feed", to: "feed#index"
      get "search", to: "search#index"

      get "users/search", to: "users#search"

      resources :users, only: [], param: :username do
        member do
          get "", to: "users#show"
          get "posts", to: "users#posts"
          get "followers", to: "users#followers"
          get "following", to: "users#following"

          post "follow", to: "follows#create"
          delete "follow", to: "follows#destroy"

          post "block", to: "blocks#create"
          delete "block", to: "blocks#destroy"

          post "mute", to: "mutes#create"
          delete "mute", to: "mutes#destroy"
        end
      end

      patch "users/:username/follow/accept", to: "follows#accept"
      patch "users/:username/follow/reject", to: "follows#reject"

      resources :follow_requests, only: [:index]

      namespace :auth do
        post :register, to: "registrations#create"
        post :login, to: "sessions#create"
        post :refresh, to: "refresh#create"
        post :confirm, to: "email_confirmations#create"
        post :resend_confirmation, to: "resend_confirmations#create"
        post :logout, to: "logout#destroy"
      end

      get :me, to: "profiles#show"
      patch :me, to: "profiles#update"

      resources :posts, only: %i[index create show update destroy] do
        resource :like, only: [:create, :destroy]
        resources :comments, only: [:index, :create, :destroy]
      end

      resources :hashtags,
                only: [],
                param: :tag do
        member do
          get :posts
        end
      end

      resources :notifications, only: [:index] do
        member do
          patch :read
        end
        collection do
          patch :read_all
          get :unread_count
        end
      end

      namespace :admin do
        resources :reports, only: %i[index update]

        patch "posts/:id/hide", to: "posts#hide"
        patch "users/:id/ban", to: "users#ban"
      end
    end
  end
end