class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    question = Question.find params[:question_id]
    like = Like.new(user: current_user, question: question)

    unless can?(:like, question)
      flash[:warning] = "That's a bit narcissistic..."
      # We'll return out of this action 
      # so that we don't try to redirect twice
      return redirect_to question_path(question)
    end

    if like.save
      flash[:success] = "Question liked!"
    else
      flash[:danger] = "Already liked"
    end

    redirect_to question_path(question)
  end

  def destroy 
    question = Question.find params[:question_id]
    like = Like.find params[:id]

    if can?(:destroy, like) 
      like.destroy
      flash[:secondary] = "Question unliked"
    else
      flash[:danger] = "Cannot unlike"
    end

    redirect_to question_path(question)
  end
end
