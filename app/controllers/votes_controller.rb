class VotesController < ApplicationController
  before_filter :require_current_user!
  before_filter :require_authorized_upvote_user!, :only => [:up]
  before_filter :require_authorized_downvote_user!, :only => [:down]

  def up
    params[:question_id] ? question("up") : answer("up")
  end

  def down
    params[:question_id] ? question("down") : answer("down")
  end

  private
    #Before Filters
    def require_authorized_upvote_user!
      unless current_user.can_vote_up?
        flash[:errors] = ["You are not authorized to vote anything up yet!"]
        params[:question_id] ? question_auth : answer_auth
      end
    end

    def require_authorized_downvote_user!
      unless current_user.can_vote_down?
        flash[:errors] = ["You are not authorized to vote anything down yet!"]
        params[:question_id] ? question_auth : answer_auth
      end
    end

    def question_auth
      redirect_to question_url(params[:question_id])
    end

    def answer_auth
      q_id = Answer.find(params[:answer_id]).question_id
      redirect_to question_url(q_id)
    end

    #Other Private Methods
    def question(dir)
      Vote.parse_vote_request(
        dir,
        params[:question_id],
        "Question",
        current_user.id)

      redirect_to question_url(params[:question_id])
    end

    def answer(dir)
      @answer = Answer.find(params[:answer_id])
      Vote.parse_vote_request(
        dir,
        params[:answer_id],
        "Answer",
        current_user.id)
      
      redirect_to question_url(@answer.question_id)
    end
end
