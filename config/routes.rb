Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'auth'
    devise_scope :user do
      post '/auth/sign_in', to: 'users/sessions#create'
    end
  end
end
