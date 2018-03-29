Rails.application.routes.draw do
  resources :scrabbles do
    resources :players do
      resources :words
    end
  end

  root 'scrabbles#index'
end
