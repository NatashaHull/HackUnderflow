class AnswersController < ApplicationController
  before_filter :require_current_user!
  before_filter :require_answer_owner!, :only => [:destroy]
  before_filter :require_question_owner!, :only => [:accept]
  before_filter :require_authorized_user!, :only => [:edit, :update]

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

    if @answer.user_id == current_user.id
      update_answer
    else
      create_edit_suggestion
    end
  end

  def destroy
    @answer.destroy
    redirect_to question_url(@answer.question_id)
  end

  def accept
    @answer.accept
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

    def require_question_owner!
      @answer = Answer.includes(:question).find(params[:answer_id])

      unless @answer.question.user_id == current_user.id
        flash[:errors] = ["Only the question owner can accept answers"]
        redirect_to question_url(@answer.question_id)
      end
    end

    def require_authorized_user!
      @answer = Answer.find(params[:id])

      unless current_user.can_edit? || @answer.user_id == current_user.id
        flash[:errors] = ["You are not authorized to edit other peoples answers"]
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
