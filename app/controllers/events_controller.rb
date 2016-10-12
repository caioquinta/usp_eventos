class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :add_participant]
  before_action :set_event, only: [:show, :edit, :add_participant, :remove_participant, :update, :destroy]
  before_action :correct_planner, only: [:edit, :destroy]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params.merge(planner: current_user))
    if @event.save
      flash[:notice] = 'Evento Criado com Sucesso'
      render 'successful'
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

  def destroy
    @event.destroy
    redirect_to root_path
  end

  def add_participant
    @event.participants.create(user_id: current_user.id) if user_signed_in?
  end

  def remove_participant
    @event.participants.find_by(user_id: current_user.id).destroy
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def correct_planner
    redirect_to root_path if @event.planner != current_user
  end

  def event_params
    params.require(:event).permit(:name, :description, :begin_date, :end_date, { tag_list: [] }, :planner, :location, :price, :avatar)
  end
end
