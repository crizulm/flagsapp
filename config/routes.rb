Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :flags
  resources :invites
  resources :reports

  put 'flags/:id/status', to: 'flags#change', as: 'change_status_flag'
  get 'flags/:id/evaluate', to: 'flags#evaluate', as: 'evaluate_flag'
  get 'home/index'
  get 'healthcheck', to: redirect('internal_test/all')
  root to: "home#index"
end
