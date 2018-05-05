Rails.application.routes.draw do

  get '/logout' => 'application#logout'
  get '/unauthenticated' => 'application#unauthenticated'
  get '/auth/:provider/callback' => 'application#oauth_callback'
  get '/auth/failure' => 'application#oauth_failure'

  namespace :api do
    resources :events
  end

  root to: 'application#index'

end
