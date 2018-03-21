Rails.application.routes.draw do
  resources :players

  root 'players#index'
end
