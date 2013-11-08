class QuestionsController < ApplicationController
  before_filter :require_current_user!, :except => [:index, :show]
  before_filter :require_question_owner!, :only => [:destroy]
  before_filter :require_authorized_user!, :only => [:edit, :update]

  def index
    @questions = Question.includes(:answers => :votes)
                         .includes(:answers => :comments)
                         .includes(:votes)
                         .includes(:comments)
                         .order("created_at desc")
                         .page(params[:page])

    @questions.sort_by! do |question|
      time = (Time.now - question.updated_at).to_i / 3600
      votes = question.vote_counts
      votes.to_f / (time + 2).to_f
    end
    @questions.reverse!

    respond_to do |format|
      format.html { render :index }
      format.json do
        render :json => { 
          :models => @questions,
          :pages => params[:page],
          :total_pages => @total_pages
        }
      end
    end
  end

  def show
    ActiveRecord::Base.transaction do
      @question = Question.includes(:answers => :votes)
                          .includes(:answers => :comments)
                          .includes(:votes)
                          .includes(:comments)
                          .find(params[:id])
      @answer = Answer.new
    end

    respond_to do |format|
      format.html { render :show }
      format.json { render :json => @question }
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
  end

  def update
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
        flash[:errors] = ["You cannot delete another person's question"]
        redirect_to @question
      end
    end

    def require_authorized_user!
      @question = Question.find(params[:id])

      unless current_user.can_edit? || @question.user_id == current_user.id
        flash[:errors] = ["You are not authorized to edit other peoples questions"]
        redirect_to @question
      end
    end

    #Private Methods
    def update_question
      if @question.update_attributes(params[:question])
        redirect_to @question
      else
        flash.now[:errors] = @question.errors.full_messages
        render :edit
      end
    end
end
