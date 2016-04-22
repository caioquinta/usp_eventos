class EventsController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :set_event, only: [:show, :edit, :add_participant, :remove_participant, :update, :destroy]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params.merge(planner: current_user))
    if @event.save
      flash[:notice] = 'Evento Criado com Sucesso'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def update
    if @event.update(event_params)
      redirect_to root_url, notice: 'Evento atualizado com sucesso.'
    else
      render 'edit'
    end
  end

  def add_participant
    @event.participants.create(user_id: current_user.id)
  end

  def remove_participant
    @event.participants.find_by(user_id: current_user.id).destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :description, :begin_date, :end_date, :planner, :location, :price)
  end
end
