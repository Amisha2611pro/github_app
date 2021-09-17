module Api
  module V1
		class EventSerializer < ActiveModel::Serializer
	    attributes :id, :event_type, :user, :repository, :created_at, :updated_at
	  end
	end
end