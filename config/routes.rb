Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: %i[create]

  resources :articles, only: %i[create index show]

  post '/login', to: 'sessions#create'

  resources :search_analytics, only: %i[index]

  get 'login', to: 'sessions#new'

  get '/', to: redirect('/login')

end
