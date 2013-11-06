class VotesController < ApplicationController
  before_filter :require_current_user!

  def up
    params[:question_id] ? question("up") : answer("up")
  end

  def down
    params[:question_id] ? question("down") : answer("down")
  end

  private
    def question(dir)
      @question = Question.find(params[:question_id])
      @vote = @question.votes.build()
      set_direction(dir)
      @vote.user_id = current_user.id

      if @vote.save
        redirect_to @question
      else
        flash.now[:errors] = @comment.errors.full_messages
        @answer = Answer.new
        render 'questions/show'
      end
    end

    def answer(dir)
      @answer = Question.find(params[:answer_id])
      @vote = @answer.votes.build()
      set_direction(dir)
      @vote.user_id = current_user.id

      if @vote.save
        redirect_to question_url(@answer.question_id)
      else
        flash.now[:errors] = @comment.errors.full_messages
        @question = @answer.question
        render 'questions/show'
      end
    end

    def set_direction(dir)
      @vote.direction = dir
    end
end
