module Api
  module V1
    class EventsController < ApplicationController
      before_action :authenticate_user!
      before_action :find_event, only: [:destroy, :show, :update]

      def index
        events = Event.all
        render :json => events, each_serializer: Api::V1::EventSerializer, status: :ok
      end

      def create
        event = Event.new(event_params.merge(user_id: current_user.id))
        if event.save
          render :json => event, each_serializer: Api::V1::EventSerializer, status: :ok
        else
          render json: {error: "event is not created"}
        end
      end

      def show
        render :json => @event, each_serializer: Api::V1::EventSerializer, status: :ok
      end

      def update
        if @event && @event.update(update_event_params)
          render :json => @event, each_serializer: Api::V1::EventSerializer, status: :ok
        else
          render json: { error: "Something went wrong, event is not updated yet" }  
        end
      end

      def destroy
        @event.destroy
        render json: { status: :success, message: "event is deleted" }
      end

      private
      def event_params
        params.require(:event).permit(:repository_id, :event_type, :user_id)
      end

      def update_event_params
        params.require(:event).permit(:event_type)
      end

      def find_event
        @event = Event.find_by_id(params[:id])
        return render json: { error: "Id is invalid" } unless @event.present?
      end

    end
  end
end
