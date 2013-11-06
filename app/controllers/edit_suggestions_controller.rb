class EditSuggestionsController < ApplicationController
  before_filter :require_current_user!, :only => [:accept]

  def show
    @suggestion = EditSuggestion.find(params[:id])
  end

  def accept
    @suggestion = EditSuggestion.find(params[:edit_suggestion_id])
    @suggestion.accept_edit
    redirect_to @suggestion.question
  end

  private

    def require_editable_owner
      @suggestion = EditSuggestion.includes(:editable)
                                  .find(params[:edit_suggestion_id])
      unless @suggestion.editable.user_id == current_user.id
        flash[:errors] = ["You cannot accept an edit unless it is on your own post"]
        redirect_to @suggestion
      end
    end
end
