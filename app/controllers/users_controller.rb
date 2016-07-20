class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :home, :about]

  def home
    if params[:tag]
      @next_events = Event.next_events.tagged_with(params[:tag], any: true)
      @current_events = Event.current_events.tagged_with(params[:tag], any: true)
    else
      @next_events = Event.next_events
      @current_events = Event.current_events
    end
  end

  def user_params
    params.require(:user).permit(events_attributes: [:id, :name, :tag_list, :_destroy])
  end
end
