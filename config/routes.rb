Rails.application.routes.draw do
  devise_for :users
  root to: "pages#login"
  resource :profile, only: [:show, :update, :edit]
  resources :bars, only: [:index, :show] do
    member do
      get :hero
    end
    resources :challenges, only: [:new, :create]
  end
  resources :challenges, only: [:update] do
    resources :challenge_requests, only: [:create, :destroy]
  end
end
