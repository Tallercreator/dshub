Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :cases, only: [:index, :show]
  get "glossary", to: "terms#index", as: :glossary
  get "glossary/:id", to: "terms#show", as: :term
  resources :resources, only: [:index]
  resources :case_applications, only: [:create]

  root "home#index"
end
