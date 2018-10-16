Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :flags
  put 'flags/:id/status', to: 'flags#change', as: 'change_status_flag'
  get 'home/index'

  root to: "home#index"
end
