Rails.application.routes.draw do
  devise_for :users
  root to: "pages#login"
  get "home", to: "pages#home"
  resource :profile, only: [:show, :update, :edit]
  resources :bars, only: [:index, :show] do
    resources :players, only: [:index]
    member do
      get :hero
    end
    resources :challenges, only: [:new, :create]
  end
  resources :challenges, only: [:update] do
    resources :challenge_requests, only: [:create, :destroy]
  end
end
