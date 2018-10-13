Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  resources :flags

  get 'home/index'
  root to: "home#index"
end
