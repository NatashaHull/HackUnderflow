class EditSuggestionsController < ApplicationController
  before_filter :require_current_user!, :except => [:show]
  before_filter :require_editable_owner!, :except => [:show]

  def show
    @suggestion = EditSuggestion.find(params[:id])
  end

  def accept
    @suggestion.accept_edit
    redirect_to @suggestion.question
  end

  def reject
    @suggestion.destroy
    redirect_to @suggestion.question
  end

  private

    def require_editable_owner!
      @suggestion = EditSuggestion.includes(:editable)
                                  .find(params[:edit_suggestion_id])
      unless @suggestion.editable.user_id == current_user.id
        flash[:errors] = ["You cannot accept an edit unless it is on your own post"]
        redirect_to @suggestion
      end
    end
end
