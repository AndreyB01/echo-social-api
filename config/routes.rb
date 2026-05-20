require "sidekiq/web"
Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount ActionCable.server => "/cable"
  mount Sidekiq::Web => "/sidekiq"
  
  namespace :api do
    namespace :v1 do
      get "feed", to: "feed#index"
      namespace :auth do
        post :register, to: "registrations#create"
        post :login, to: "sessions#create"
        post :refresh, to: "refresh#create"

        delete :logout, to: "logout#destroy"
        delete :logout_all, to: "logout#destroy_all"
      end
      get :profile, to: "profiles#show"
      resources :posts, only: %i[index create show update destroy] do
  resource :like, only: [:create, :destroy]
  resources :comments, only: [:index, :create, :destroy]
end

      resources :hashtags, only: [] do
        get :posts, to: "hashtags#posts", on: :member
      end

      resources :users, only: [] do
        member do
          post "follow", to: "follows#create"
          delete "follow", to: "follows#destroy"
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
    end
  end
end