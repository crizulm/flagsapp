Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  
  get 'home/index'
  get 'flag', to:'flags#postFlag'

  root to: "home#index"
end
