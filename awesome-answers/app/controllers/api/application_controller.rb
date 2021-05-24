class Api::ApplicationController < ApplicationController
    skip_before_action :verify_authenticity_token

    def authenticate_user!
        render(
            json: {errors: "you are not logged in"},
            status: 422
        ) unless user_signed_in?
    end
end
