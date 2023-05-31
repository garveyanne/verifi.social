Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :image_results, only: [:index, :show, :new, :create, :destroy] do
    resources :cells, only: [:index, :new, :create]
  end
  resources :posts do
    resources :comments, only: [:new, :create, :edit, :update, :destroy]
  end

  get '/tagged', to: "posts#tagged", as: :tagged
end
