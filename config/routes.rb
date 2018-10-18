Rails.application.routes.draw do
  devise_for :users,
             controllers: { sessions: 'users/sessions', registrations: 'users/registrations', omniauth_callbacks: 'users/omniauth_callbacks' },
             skip: [:registrations]
  as :user do
    get 'users/sign_up', to: 'users/registrations#new', as: 'new_user_registration'
    post 'users', to: 'users/registrations#create', as: 'user_registration'
  end

  get 'home', to: 'home#index'

  resources :flags, :only => [:index, :create, :new, :show, :destroy]
  put 'flags/:id/status', to: 'flags#change', as: 'change_status_flag'
  get 'flags/:id/evaluate', to: 'flags#evaluate', as: 'evaluate_flag'
  get 'filter', to: 'flags#filter'

  resources :reports, :only => [:index, :show]

  resources :invites, :only => [:create, :new]

  get 'healthcheck', to: 'ok_computer/ok_computer#index'

  root to: "home#index"
end
