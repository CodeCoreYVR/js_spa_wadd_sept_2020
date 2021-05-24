class Api::V1::UsersController < Api::ApplicationController

    def create
        user_params = params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
        user = User.new user_params
        if user.save
            session[:user_id] = user.id
            render json: {id: user.id}
        else
            render(
                json: {errors: user.errors.messages},
                status: 422 #Unprocessable entity
            )
        end
    end
end
