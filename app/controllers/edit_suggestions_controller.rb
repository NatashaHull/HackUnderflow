class EditSuggestionsController < ApplicationController
  before_filter :require_current_user!, :except => [:show]
  before_filter :require_editable_owner!, :except => [:show]

  def show
    @suggestion = EditSuggestion.includes(:editable).find(params[:id])

    respond_to do |format|
      format.html { render :show }
      format.json { render :json => @suggestion, :include => [:editable] }
    end
  end

  def accept
    @suggestion.accept_edit

    respond_to do |format|
      format.html { 
        p "I'm in html even though I should be in json"
        debugger
        redirect_to @suggestion.question }
      format.json { render :json => @suggestion }
    end
  end

  def reject
    @suggestion.destroy
    
    respond_to do |format|
      format.html { redirect_to @suggestion.question }
      format.json { render :json => @suggestion }
    end
  end

  private

    def require_editable_owner!
      @suggestion = EditSuggestion.includes(:editable)
                                  .find(params[:edit_suggestion_id])
      unless @suggestion.editable.user_id == current_user.id
        flash[:errors] = ["You cannot accept an edit unless it is on your own post"]
        main_server_redirect
      end
    end

    #API Stuff
    def main_server_redirect
      respond_to do |format|
        format.html { redirect_to @suggestion }
        format.json { render :json => flash[:errors],
                   :status => :unprocessable_entity }
      end
    end
end
