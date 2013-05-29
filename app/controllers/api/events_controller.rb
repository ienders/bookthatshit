class Api::EventsController < ApplicationController

  before_filter :authenticate

  respond_to :json

  def index
    @events = Event.ordered
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new_with_session(params[:event], session)
    unless @event.save
      return render json: @event.errors, status: :unprocessable_entity
    end
    render action: :show
  end

  def update
    @event = get_event
    unless @event.update_safe_attributes(params[:event])
      return render json: @event.errors, status: :unprocessable_entity
    end
    render action: :show
  end
	
  def destroy
    @event = get_event
    @event.destroy
    head :no_content
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: 'Invalid Record', status: :not_found
  end


  protected
  def get_event
    Event.owned_by(session[:email]).find(params[:id])
  end

end