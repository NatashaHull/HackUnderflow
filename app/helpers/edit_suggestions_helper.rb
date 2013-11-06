module EditSuggestionsHelper
  def create_edit_suggestion
    @question ? create_question_edit : create_answer_edit
  end

  def create_question_edit
    @suggestion = @question.edit_suggestions.build(
      :body => params[:question][:body]
      )
    @suggestion.user_id = current_user.id

    if @suggestion.save
      redirect_to @question
    else
      flash.now[:errors] = @suggestion.errors.full_messages
      render :edit
    end
  end

  def create_answer_edit
    @suggestion = @answer.edit_suggestions.build(
      :body => params[:answer][:body]
      )
    @suggestion.user_id = current_user.id

    if @suggestion.save
      redirect_to question_url(@answer.question_id)
    else
      flash.now[:errors] = @suggestion.errors.full_messages
      render :edit
    end
  end
end
