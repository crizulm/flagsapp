Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  
  get 'home/index'
  get 'flag', to:'flags#postFlag'

  root to: "home#index"
end
