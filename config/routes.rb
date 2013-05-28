Bookthatshit::Application.routes.draw do

  match '/logout' => 'application#logout'
  match '/unauthenticated' => 'application#unauthenticated'
  match '/auth/:provider/callback' => 'application#oauth_callback'
  match '/auth/failure' => 'application#oauth_failure'

  root :to => 'application#index'

end
