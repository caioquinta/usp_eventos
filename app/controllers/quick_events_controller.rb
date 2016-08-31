class QuickEventsController < ApplicationController
  def create
    @event = QuickEvent.new(quick_event_params.merge(user: current_user))
    flash[:notice] = 'Evento Criado com Sucesso' if @event.save
    render 'index'
  end

  def quick_event_params
    params.require(:quick_event).permit(:message)
  end
end
