class Api::EventsController < ApplicationController

  before_action :authenticate

  respond_to :json

  def index
    @events = Event.ordered
  end

  def show
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(
      event_params.merge(
        booked_by_email: session[:email],
        booked_by_name: session[:name]
      )
    )
    unless @event.save
      return render json: @event.errors, status: :unprocessable_entity
    end
    render action: :show
  end

  def update
    @event = get_event
    unless @event.update(event_params)
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

  rescue_from  ActionController::ParameterMissing do |e|
    render json: e.message, status: 422
  end

  protected
  def get_event
    Event.owned_by(session[:email]).find(params[:id])
  end

  def event_params
    params.require(:event).permit(:description, :date)
  end

end