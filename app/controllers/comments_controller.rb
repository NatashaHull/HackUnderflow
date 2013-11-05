class CommentsController < ApplicationController
  before_filter :require_current_user!

  def create
    params[:question_id] ? create_for_question : create_for_answer
  end

  private

    def create_for_question
      @question = Question.find(params[:question_id])
      @comment = @question.comments.build(params[:comment])
      @comment.user_id = current_user.id

      if @comment.save
        redirect_to @question
      else
        flash.now[:errors] = @comment.errors.full_messages
        @answer = Answer.new
        render 'questions/show'
      end
    end

    def create_for_answer
      @answer = Answer.find(params[:answer_id])
      @comment = @answer.comments.build(params[:comment])
      @comment.user_id = current_user.id

      if @comment.save
        redirect_to question_url(@answer.question_id)
      else
        flash.now[:errors] = @comment.errors.full_messages
        @question = @answer.question
        render 'questions/show'
      end
    end
end