Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  resources :flags

  root to: "flags#index"
end
