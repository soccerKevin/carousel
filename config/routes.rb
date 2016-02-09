Rails.application.routes.draw do
  resources :docs, only: :index
  root "static#index"
end
