class AnswersController < ApplicationController
  before_action :authenticate_user!
  
  def create
    @question = Question.find params[:question_id]
    @answer = Answer.new answer_params
    @answer.question = @question
    @answer.user = current_user
    if @answer.save
      flash[:light] = "Answer written"
      redirect_to question_path(@question)
    else 
      render "questions/show"
    end
  end
  
  def destroy
    @answer = Answer.find params[:id]
    if can?(:crud, @answer)
      @answer.destroy
      flash[:danger] = "Answer deleted"
      redirect_to question_path(@answer.question)
    else
      # head will send an empty HTTP response with a particular response code
      # :unauthorized code is 401
      head :unauthorized
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
