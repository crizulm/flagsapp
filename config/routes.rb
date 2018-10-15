Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  resources :flags
  put 'flags/:id/status', to: 'flags#change', as: 'change_status_flag'
  get 'home/index'

  root to: "home#index"
end
