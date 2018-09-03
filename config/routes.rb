Rails.application.routes.draw do
  devise_for :site_users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  resource :site_bot, only: [:create, :new, :show]
end
