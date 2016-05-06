class SuggestionsController < ApplicationController
  def create
    @suggestion = Suggestion.new(suggestion_params)
    @suggestion.save ? (flash[:notice] = 'Sugestão enviada com sucesso') : flash[:alert] = 'Preencha seu nome, email e a sugestão que deseja enviar'
    redirect_to root_url
  end

  private

  def suggestion_params
    params.require(:suggestion).permit(:user_name, :email, :description)
  end
end
