class QuickEventsController < ApplicationController
  def create
    @event = QuickEvent.new(quick_event_params.merge(user: current_user))
    if @event.save
      flash[:notice] = 'Evento Criado com Sucesso'
      render 'index'
    else
      render 'index'
    end
  end

  def quick_event_params
    params.require(:quick_event).permit(:message)
  end
end
