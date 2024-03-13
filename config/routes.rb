Rails.application.routes.draw do
  devise_for :users
  root to: "pages#login"
  resource :profile, only: [:show, :update, :edit]
  resources :bars, only: [:index, :show] do
    resources :players, only: [:index]
    member do
      get :hero
    end
    resources :challenges, only: [:new, :create]
  end
  resources :barsmap, only: [:index]
  resources :challenges, only: [:update, :show] do
    member do
      get :update_winner
    end
    resources :challenge_requests, only: [:create, :destroy]
    resources :games, only: [:show] do
      member do
        get :memory, to: "games#memory"
        get :taptabiere, to: "games#taptabiere"
        get :customgame, to: "games#customgame"
      end
    end
    resources :messages, only: :create
    resource :result, only: [:show]
  end
end
