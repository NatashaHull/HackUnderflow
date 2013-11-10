class QuestionsController < ApplicationController
  before_filter :require_current_user!, :except => [:index, :show]
  before_filter :require_question_owner!, :only => [:destroy]
  before_filter :require_authorized_user!, :only => [:edit, :update]

  def index
    @questions = preloaded_questions.order("created_at desc")
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
      @question = preloaded_questions.find(params[:id])
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
      respond_to do |format|
        format.html { redirect_to @question }
        format.json { render :json => @question }
      end
    else
      flash.now[:errors] = @question.errors.full_messages
      
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => flash[:errors],
                             :status => :unprocessable_entity }
      end
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
    respond_to do |format|
      format.html { redirect_to questions_url }
      format.json { render :json => @question }
    end
  end

  private
    #Before Filters
    def require_question_owner!
      @question = preloaded_questions.find(params[:id])

      unless @question.user_id == current_user.id
        flash[:errors] = ["You cannot delete another person's question"]
        main_server_redirect
      end
    end

    def require_authorized_user!
      @question = preloaded_questions.find(params[:id])

      unless current_user.can_edit? || @question.user_id == current_user.id
        flash[:errors] = ["You are not authorized to edit other peoples questions"]
        main_server_redirect
      end
    end

    #Private Methods
    def update_question
      if @question.update_attributes(params[:question])
        respond_to do |format|
          format.html { redirect_to @question }
          format.json { render :json => @question }
        end
      else
        flash.now[:errors] = @question.errors.full_messages
        
        respond_to do |format|
          format.html { render :edit }
          format.json { render :json => flash[:errors],
                             :status => :unprocessable_entity }
        end
      end
    end

    #SQL query reducing methods
    def preloaded_questions
      Question.includes(:answers => :votes)
              .includes(:answers => :comments)
              .includes(:answers => :user)
              .includes(:user)
              .includes(:votes)
              .includes(:comments)
    end

    #API Stuff
    def main_server_redirect
      respond_to do |format|
        format.html { redirect_to @question }
        format.json { render :json => flash[:errors],
                   :status => :unprocessable_entity }
      end
    end
end
