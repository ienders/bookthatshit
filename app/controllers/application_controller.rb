class ApplicationController < ActionController::Base

  before_action :authenticate, only: [ :index ]

  def index
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

  protected
  def authenticate
    return true if session[:email]
    respond_to do |format|
      format.html { redirect_to action: 'unauthenticated' }
      format.json { head :unauthorized }
    end
  end

end
