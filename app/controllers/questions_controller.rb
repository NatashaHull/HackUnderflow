class QuestionsController < ApplicationController
  before_filter :require_current_user!, :except => [:index, :show]
  before_filter :require_question_owner!, :only => [:edit, :update, :destroy]

  def index
    @questions = Question.includes(:votes).all
  end

  def show
    ActiveRecord::Base.transaction do
      @question = Question.includes(:votes).find(params[:id])
      @answers = @question.answers.includes(:votes).includes(:comments)
      @answer = Answer.new
    end
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params[:question])
    @question.user_id = current_user.id

    if @question.save
      redirect_to @question
    else
      flash.now[:errors] = @question.errors.full_messages
      render :new
    end
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])

    if @question.user_id == current_user.id
      update_question
    else
      create_edit_suggestion
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_url
  end

  private
    #Before Filters
    def require_question_owner!
      @question = Question.find(params[:id])

      unless @question.user_id == current_user.id
        flash[:errors] = ["You cannot edit another person's question"]
        redirect_to @question
      end
    end

    #Private Methods
    def update_answer
      if @question.update_attributes(params[:question])
        redirect_to @question
      else
        flash.now[:errors] = @question.errors.full_messages
        render :edit
      end
    end
end
