Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  root to: "pages#home"
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :image_results, only: [:index, :show, :new, :create, :destroy] do
    resources :cells, only: [:index, :new, :create]
    member do
      patch :update_cells
    end
  end

  resources :posts do
    resources :comments, only: [:new, :create, :edit, :update, :destroy]
  end

  get '/tagged', to: "posts#tagged", as: :tagged
end
