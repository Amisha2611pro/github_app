module Api
  module V1
    class SessionsController < Devise::SessionsController
      
      def create
        @user = warden.authenticate!(auth_options)
        @token = Tiddle.create_and_return_token(@user, request, expires_in: 1.month)
        user_details = {id: @user.id, username: @user.username, email: @user.email}
        render json: { message: "User successfully logged in", user_details: user_details, authentication_token: @token, status: 200 }
      end

      def destroy
        if current_user
          Tiddle.expire_token(current_user, request) 
          render json: {message: "successfully Logout", status:"success"}
        else
          render json: {error: "Invalid Token", status:"fail"}
        end
      end
     
       private

      # this is invoked before destroy and we have to override it
      def verify_signed_out_user; end
      def resource_name
        :user
      end
    end
  end
end