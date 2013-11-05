class QuestionsController < ApplicationController
  before_filter :require_current_user!, :except => [:index, :show]
  before_filter :require_question_owner!, :only => [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
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
    @question = @question

    if @question.update_attributes(params[:question])
      redirect_to @question
    else
      flash.now[:errors] = @question.errors.full_messages
      render :new
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_url
  end

  private

    def require_question_owner!
      @question = Question.find(params[:id])

      unless @question.user_id == current_user.id
        flash[:errors] = ["You cannot edit another person's question"]
        redirect_to @question
      end
    end
end
