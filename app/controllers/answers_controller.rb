class AnswersController < ApplicationController
  before_filter :require_current_user!
  before_filter :require_answer_owner!

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
    @answer = Question.find(params[:id])
  end

  def update
    if @answer.update_attributes(params[:answer])
      redirect_to @answer
    else
      flash.now[:errors] = @answer.errors.full_messages
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_url(@answer.question_id)
  end

  private

    def require_answer_owner!
      @answer = Answer.find(params[:id])

      unless @answer.user_id == current_user.id
        flash[:errors] = ["You cannot edit another person's answer"]
        redirect_to question_url(@answer.question_id)
      end
    end
end
