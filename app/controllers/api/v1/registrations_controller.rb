module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      before_action :configure_permitted_parameters, only: :create
      skip_before_action :verify_authenticity_token, only: :create
      
      def create
        build_resource(sign_up_params)
        if User.find_by_email(resource.email)
          render json: { message: "This user is already present", status: 404 }
          return
        else
          resource.save
          token = Tiddle.create_and_return_token(resource, request)
          yield resource if block_given?
        end
        unless resource.persisted?
          clean_up_passwords resource
          set_minimum_password_length
          return render json:{errors: resource.errors.as_json}
        end
        if resource.active_for_authentication?
          sign_up(resource_name, resource)
        else
          expire_data_after_sign_in!
        end
        @user = {id: resource.id, username: resource.username, email: resource.email, auth_token: token}
        render json: { status: :success, message: "User created successfully",user: @user }
      end

      def show
        render json: {user: user_format}
      end

      def update
        if current_user.update(update_params)
          render json: {status: :success, message: "User updated successfully", user: user_format}
        else
          render json: {error: "User is not updated", status: 422}
        end
      end

      def destroy
        if current_user.destroy
          render json: {status: :success, message: "User is deleted"}
        else
          render json: {error: "something went wrong"}
        end
      end
      
      protected
      def configure_permitted_parameters
        param_keys = [:username, :email, :password ]
        devise_parameter_sanitizer.permit(:sign_up, keys: param_keys)
      end
      def resource_name
        :user
      end
      def user_format
        {id: current_user.id, username: current_user.username, email: current_user.email}
      end
    end
  end
end
