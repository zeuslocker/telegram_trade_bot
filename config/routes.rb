require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :site_users
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  resource :site_bot, only: [:create, :new, :show]
end
