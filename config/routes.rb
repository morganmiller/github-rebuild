Rails.application.routes.draw do
  root to: 'welcome#index'
  
  get '/auth/github', as: 'login'
  get '/auth/github/callback', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy', as: 'logout'
end
