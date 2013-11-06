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
      Vote.parse_vote_request(
        dir,
        params[:question_id],
        "Question",
        current_user.id)

      redirect_to question_url(params[:question_id])
    end

    def answer(dir)
      @answer = Question.find(params[:answer_id])
      Vote.parse_vote_request(
        dir,
        params[:answer_id],
        "Answer",
        current_user.id)
      
      redirect_to question_url(@answer.question_id)
    end
end
