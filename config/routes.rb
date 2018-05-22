Rails.application.routes.draw do
  devise_for :users
  resources :scrabbles do
    resources :players do
      resources :words
    end
  end

  root 'scrabbles#index'
end
