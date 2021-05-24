class Api::V1::QuestionsController < Api::ApplicationController
    before_action :find_question, only:[:show, :destroy, :update]
    before_action :authenticate_user!, only:[:create, :destroy, :update]

    def index
        questions = Question.order created_at: :desc
        render json: questions, each_serializer: QuestionCollectionSerializer
    end

    def show
        #question = Question.find params[:id]
        render json: @question
    end

    def destroy
        #question = Question.find params[:id]
        if @question.destroy
            head :ok
        else
            head :bad_request
        end
    end

    def create
        question = Question.new question_params
        question.user = current_user
        if question.save
            render json: {id: question.id}
        else
            render(
                json: {errors: question.errors},
                status: 422 #unprocessable entity HTTP status code
            )
        end
    end

    def update
        if @question.update question_params
            render json: {id: @question.id}
        else
            render(
                json: {errors: @question.errors},
                status: 422
            )
        end    
    end

    private
    def find_question
        @question = Question.find params[:id]
    end
    def question_params
        params.require(:question).permit(:title, :body, :tag_names)
    end
end


# Use this command to generate questions controller 'rails g controller api/v1/questions --no-assets --no-helper --skip-template-engine'