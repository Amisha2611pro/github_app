module Api
  module V1
    class RepositoriesController < ApplicationController
      before_action :authenticate_user!
      before_action :find_repository, only: [:destroy, :show, :update]

      def index
        repositories = Repository.all
        render :json => repositories, each_serializer: Api::V1::RepositorySerializer, status: :ok
      end

      def create
        repository = Repository.new(repository_params.merge(user_id: current_user.id))
        if repository.save
          render :json => repository, each_serializer: Api::V1::RepositorySerializer, status: :ok
        else
          render json: {error: "repository is not created"}
        end
      end

      def show
        render :json => @repository, each_serializer: Api::V1::RepositorySerializer, status: :ok
      end

      def update
        if @repository && @repository.update(repository_params)
          render :json => @repository, each_serializer: Api::V1::RepositorySerializer, status: :ok
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
          render :json => events, each_serializer: Api::V1::EventSerializer, status: :ok
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