class CommentsController < ApplicationController
  before_filter :require_current_user!
  before_filter :require_authorized_user!

  def new
    ActiveRecord::Base.transaction do
      if params[:question_id]
        @answers = @question.answers.includes(:votes)
      else
        @question = @answer.question.includes(:votes)
      end
    end

    @comment = Comment.new
  end

  def create
    params[:question_id] ? create_for_question : create_for_answer
  end

  private
    #Before Filters
    def require_authorized_user!
      params[:question_id] ? question_auth : answer_auth
    end

    def question_auth
      @question = Question.find(params[:question_id])
      unless current_user.can_comment?
        flash[:errors] = ["You do not have enough points to comment"]
        redirect_to @question
      end
    end

    def answer_auth
      @answer = Answer.includes(:votes).find(params[:answer_id])
      unless current_user.can_comment?
        flash[:errors] = ["You do not have enough points to comment"]
        redirect_to question_url(@answer.question_id)
      end
    end

    #Private Methods
    def create_for_question
      @question = Question.find(params[:question_id])
      @comment = @question.comments.build(params[:comment])
      @comment.user_id = current_user.id

      if @comment.save
        respond_to do |format|
          format.html { redirect_to @question }
          format.json { render :json => @comment }
        end
      else
        flash.now[:errors] = @comment.errors.full_messages
        @answers = @question.answers.includes(:votes).includes(:comments)
        error_server_response
      end
    end

    def create_for_answer
      @answer = Answer.find(params[:answer_id])
      @comment = @answer.comments.build(params[:comment])
      @comment.user_id = current_user.id

      if @comment.save
        respond_to do |format|
          format.html { redirect_to question_url(@answer.question_id) }
          format.json { render :json => @comment }
        end
      else
        flash.now[:errors] = @comment.errors.full_messages
        @question = @answer.question.includes(:votes).includes(:comments)
        error_server_response
      end
    end

    #API Stuff
    def error_server_response
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => flash[:errors],
                             :status => :unprocessable_entity }
      end
    end
end