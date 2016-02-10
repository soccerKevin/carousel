Rails.application.routes.draw do
  resources :docs, only: :index
  get '/:page' => 'docs#index'
  get '/class/:page' => 'docs#class_name'
  root "static#index"
end
