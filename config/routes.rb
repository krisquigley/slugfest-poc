Rails.application.routes.draw do
  root 'products#index'

  resource :admin, only: [:edit, :update]
  resources :products, only: [:edit, :update, :new, :create, :index]

  get '/*slug_parts', to: 'slugs#show'
end
