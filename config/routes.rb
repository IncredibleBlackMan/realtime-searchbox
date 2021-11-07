Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: %i[create]

  resources :articles, only: %i[create index show]

  resources :sessions, only: %i[create]

  resources :search_analytics, only: %i[index]

  get 'sessions', to: 'sessions#new'

end
