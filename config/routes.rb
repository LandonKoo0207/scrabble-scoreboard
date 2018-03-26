Rails.application.routes.draw do
  resources :players do
    resources :words
  end

  root 'players#index'
end
