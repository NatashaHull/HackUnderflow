class AnswersController < ApplicationController
  before_filter :require_current_user!
  before_filter :require_answer_owner!, :only => [:destroy]

  def create
    @answer = Answer.new(params[:answer])
    @answer.question_id = params[:question_id]
    @answer.user_id = current_user.id

    if @answer.save
      flash[:errors] = @answer.errors.full_messages
    end
    redirect_to question_url(@answer.question_id)
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])

    if @answer.user_id == current_user
      update_answer
    else
      create_edit_suggestion
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_url(@answer.question_id)
  end

  private
    #Before Filters
    def require_answer_owner!
      @answer = Answer.find(params[:id])

      unless @answer.user_id == current_user.id
        flash[:errors] = ["You cannot edit another person's answer"]
        redirect_to question_url(@answer.question_id)
      end
    end

    #Private Methods
    def update_answer
      if @answer.update_attributes(params[:answer])
        redirect_to question_url(@answer.question_id)
      else
        flash.now[:errors] = @answer.errors.full_messages
        render :edit
      end
    end
end
