class QuestionsController < ApplicationController
  # Pass a method name as a symbol to "before_action" to run it before all of the actions listed
  # This will find the question using the "id" from the params and save it to @question,
  # so all of the actions listed has the @question defined.
  before_action :authenticate_user!, except: [:show, :index]
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  # find_question needs to come before authorize because we need the @question to check
  # our abilities
  before_action :authorize, only: [:edit, :update, :destroy] 

  def new
    # Create a new instance of a question which will be
    # available as an argument to "form_with"
    @question = Question.new
  end

  def create
    # The "params" hash is available in controllers and it 
    # includes the query string, url params, and the body of a 
    # form submission.

    # Render the params as JSON to view a readable format of 
    # the data. This is like doing response.send(req.body) in Express:
    # render json: params

    @question = Question.new question_params
    @question.user = current_user
 
    if @question.save
      # Use "redirect_to" to tell the browser to make a new request.
      # The method takes in a route helper as an argument. For the 
      # show route, we pass an id to the url helper for the question
      # to render. But we can also just pass the instance of the question 
      # and rails knows to grab the id from the instance:
      # redirect_to question_path(@question)
      flash[:primary] = "#{@question.title} created"
      redirect_to question_path(@question.id)
    else
      # If we use "redirect_to", the data in the body will be gone from
      # the params. Therefore we will render the new page so the user
      # can see their inputs in the form to modify it if it failed 
      # validation.
      render :new
    end
  end

  def show
    # For form_with
    @answer = Answer.new 

    # For list of answers to display
    @answers = @question.answers.order(created_at: :desc)

    # Finds the like of the question by the current_user
    # If user did not previously like, @like will be nil
    @like = @question.likes.find_by(user: current_user)
  end

  def index
    if params[:tag].present?
      @tag = Tag.find_or_initialize_by(name: params[:tag])
      @questions = @tag.questions.order(created_at: :desc)
    else
      @questions = Question.all.order(created_at: :desc)
    end

    respond_to do |format|
      format.html {render}
      format.json { render json: @questions}
    end

  end

  def edit
  end

  def update
    if @question.update question_params
      flash[:dark] = "#{@question.title} updated"
      redirect_to question_path(@question)
    else
      render :edit 
    end
  end
  
  def destroy
    @question.destroy
    flash[:danger] = "#{@question.title} deleted"
    redirect_to questions_path
  end

  private

  def question_params
    # Use "require" on the params object to retrieve the nested 
    # hash of a key corresponding to the form data. We can also 
    # use "permit" to specify all input names that are allowable
    # because sometimes we don't need all the values from a form.
    
    # We need to pass an array to specify that it will be a
    # multi-selection from the form if we use checkboxes
    # params.require(:question).permit(:title, :body, tag_ids: [])
    params.require(:question).permit(:title, :body, :tag_names)
  end

  def find_question
    @question = Question.find params[:id]
  end

  def authorize
    unless can?(:crud, @question)
      flash[:danger] = "Not Authorized"
      redirect_to root_path
    end
  end
end
