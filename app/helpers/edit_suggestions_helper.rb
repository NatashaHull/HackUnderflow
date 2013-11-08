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
      respond_to do |format|
        format.html { redirect_to @question }
        format.json { render :json => @suggestion }
      end
    else
      flash.now[:errors] = @suggestion.errors.full_messages
      suggestion_errors_render('question/edit')
    end
  end

  def create_answer_edit
    @suggestion = @answer.edit_suggestions.build(
      :body => params[:answer][:body]
      )
    @suggestion.user_id = current_user.id

    if @suggestion.save
      respond_to do |format|
        format.html { redirect_to question_url(@answer.question_id) }
        format.json { render :json => @suggestion }
      end
    else
      flash.now[:errors] = @suggestion.errors.full_messages
      suggestion_errors_render('answer/edit')
    end
  end

  def suggestion_errors_render(view)
    respond_to do |format|
      format.html { render view }
      format.json { render :json => flash[:errors],
                           :status => :unprocessable_entity }
    end
  end
end
