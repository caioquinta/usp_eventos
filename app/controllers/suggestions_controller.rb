class SuggestionsController < ApplicationController
  def new
    @suggestion = Suggestion.new
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    flash[:notice] = 'Sugestão enviada com sucesso' if @suggestion.save
    redirect_to root_url
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:user_name, :email, :description)
  end
end
