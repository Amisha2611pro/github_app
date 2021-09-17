module Api
  module V1
    class RepositoriesController < ApplicationController
      before_action :authenticate_user!
      before_action :find_repository, only: [:destroy, :show, :update]

      def index
        repositories = Repository.all
        render json: { status: :success, repositories: repositories,  message: "Got all repository successfully" }
      end

      def create
        repository = Repository.new(repository_params)
        repository.user_id = current_user.id
        if repository.save
          render json:  {repository: repository, status: :success, message: "repository created successfully"}
        else
          render json: {error: "repository is not created"}
        end
      end

      def show
        render json: {status: :success, repository: @repository }
      end

      def update
        if @repository && @repository.update(repository_params)
          render json: { status: :success, repository: @repository, message: "repository updated successfully"}
        else
          render json: { error: "Something went wrong, repository is not updated yet" } 
        end
      end

      def destroy
        @repository.destroy
        render json: { status: :success, message: "repository is deleted" }
      end

      def events
        events = Event.where(repository_id: params[:repository_id])
        if events.present?
          render json: { status: :success, events: events, message: "Got all events" }
        else
          render json: { error: "Something went wrong, event not present" } 
        end
      end

      private
      def repository_params
        params.require(:repository).permit(:user_id, :repository_name, :privacy, :description)
      end

      def find_repository
        @repository = Repository.find_by_id(params[:id])
        return render json: { error: "Id is invalid", status: 404 } unless @repository.present?
      end
    end
  end
end