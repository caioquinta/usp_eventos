class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :add_participant, :update, :destroy]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params.merge(planner: current_user))
    if @event.save
      redirect_to root_url, notice: 'Evento Criado com Sucesso'
    else
      render 'events_new'
    end
  end

  def add_participant
    @event.participants.create(user_id: current_user.id)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :begin_date, :end_date, :planner)
  end
end
