class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_response

    def show
        user = User.find(session[:user_id])
        render json: user, status: :ok
    end

    def create
        user = User.create(user_params)
        if user.valid?
            session[:user_id] = user.id
            render json: user, status: :created
        else
            render json: {errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    private
    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def not_found_response
        render json: {errors: "No user logged in" }, status: :unauthorized
    end
end
