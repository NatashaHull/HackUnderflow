class VotesController < ApplicationController
  before_filter :require_current_user!
  before_filter :require_non_author!
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
    def require_non_author!
      params[:question_id] ? question_non_author : answer_non_author
    end

    def question_non_author
      @question = Question.find(params[:question_id])
      if @question.user_id == current_user.id
        non_author_auth(@question, @question)
      end
    end

    def answer_non_author
      @answer = Answer.find(params[:answer_id])
      if @answer.user_id == current_user.id
        non_author_auth(@answer, question_url(@answer.question_id))
      end
    end

    def non_author_auth(obj, url)
      flash[:errors] = ["You can't vote on your own #{obj}"]
      
      respond_to do |format|
        format.html { redirect_to url }
        format.json { render :json => flash[:errors],
                   :status => :unprocessable_entity }
      end
    end

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
      respond_to do |format|
        format.html { redirect_to question_url(params[:question_id]) }
        format.json { render :json => flash[:errors],
                   :status => :unprocessable_entity }
      end
    end

    def answer_auth
      q_id = Answer.find(params[:answer_id]).question_id
      
      respond_to do |format|
        format.html { redirect_to question_url(q_id) }
        format.json { render :json => flash[:errors],
                   :status => :unprocessable_entity }
      end
    end

    #Other Private Methods
    def question(dir)
      vote = Vote.parse_vote_request(
        dir,
        params[:question_id],
        "Question",
        current_user.id)

      respond_to do |format|
        format.html { redirect_to question_url(params[:question_id]) }
        format.json { render :json => vote }
      end
    end

    def answer(dir)
      @answer = Answer.find(params[:answer_id])
      vote = Vote.parse_vote_request(
        dir,
        params[:answer_id],
        "Answer",
        current_user.id)
      
      respond_to do |format|
        format.html { redirect_to question_url(@answer.question_id) }
        format.json { render :json => vote }
      end
    end
end
