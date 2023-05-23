Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :image_results, only: [:index, :show, :new, :create, :destroy]
  resources :posts do
    resources :comments
  end


  get '/tagged', to: "posts#tagged", as: :tagged

end
