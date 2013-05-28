class ApplicationController < ActionController::Base

  protect_from_forgery

  def index
    redirect_to action: 'unauthenticated' unless session[:email]
  end

  def logout
    reset_session
    redirect_to action: 'unauthenticated'
  end

  def unauthenticated
  end

  def oauth_callback
    auth = request.env['omniauth.auth']
    session[:name] = auth['info']['name']
    session[:email] = auth['info']['email']
    redirect_to action: 'index'
  end

  def oauth_failure
    redirect_to action: 'index'
  end

end
