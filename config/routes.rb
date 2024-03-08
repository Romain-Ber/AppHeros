Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resource :profile, only: [:show, :update, :edit]
  resources :bars, only: [:index, :show] do
    resources :players, only: [:index]
    member do
      get :hero
    end
    resources :challenges, only: [:new, :create]
  end
  resources :challenges, only: [:update, :show] do
    resources :challenge_requests, only: [:create, :destroy]
    resource :game, only: [:show]
    resource :result, only: [:show]
  end
end
