class AnswersController < ApplicationController
  before_filter :require_current_user!
  before_filter :require_non_question_owner!, :only => [:create]
  before_filter :require_answer_owner!, :only => [:destroy]
  before_filter :require_question_owner!, :only => [:accept]
  before_filter :require_authorized_user!, :only => [:edit, :update]

  def create
    @answer = Answer.new(params[:answer])
    @answer.question_id = params[:question_id]
    @answer.user_id = current_user.id

    if @answer.save
      main_server_response
    else
      flash[:errors] = @answer.errors.full_messages
      
      respond_to do |format|
        format.html { redirect_to question_url(@answer.question_id) }
        format.json { render :json => flash[:errors],
                           :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])

    if @answer.user_id == current_user.id
      update_answer
    else
      create_edit_suggestion
    end
  end

  def destroy
    @answer.destroy
    main_server_response
  end

  def accept
    @answer.accept
    main_server_response
  end

  private
    #Before Filters
    def require_answer_owner!
      @answer = Answer.find(params[:id])

      unless @answer.user_id == current_user.id
        flash[:errors] = ["You cannot edit another person's answer"]
        main_redirect_server_response
      end
    end

    def require_non_question_owner!
      @question = Question.find(params[:question_id])

      if @question.user_id == current_user.id
        flash[:errors] = ["You cannot answer your own question!"]

        respond_to do |format|
          format.html { redirect_to @question }
          format.json { render :json => flash[:errors],
                     :status => :unprocessable_entity }
        end
      end
    end

    def require_question_owner!
      @answer = Answer.includes(:question).find(params[:answer_id])

      unless @answer.question.user_id == current_user.id
        flash[:errors] = ["Only the question owner can accept answers"]
        main_redirect_server_response
      end
    end

    def require_authorized_user!
      @answer = Answer.find(params[:id])

      unless current_user.can_edit? || @answer.user_id == current_user.id
        flash[:errors] = ["You are not authorized to edit other peoples answers"]
        main_redirect_server_response
      end
    end

    #Private Methods
    def update_answer
      if @answer.update_attributes(params[:answer])
        main_server_response
      else
        flash.now[:errors] = @answer.errors.full_messages

        respond_to do |format|
          format.html { render :edit }
          format.json { render :json => flash[:errors],
                     :status => :unprocessable_entity }
        end
      end
    end

    #API Stuff
    def main_server_response
      respond_to do |format|
        format.html { redirect_to question_url(@answer.question_id) }
        format.json { render :json => @answer }
      end
    end

    def main_redirect_server_response
      respond_to do |format|
        format.html { redirect_to question_url(@answer.question_id) }
        format.json { render :json => flash[:errors],
                   :status => :unprocessable_entity }
      end
    end
end
