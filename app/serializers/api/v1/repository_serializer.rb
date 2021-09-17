module Api
  module V1
		class RepositorySerializer < ActiveModel::Serializer
	    attributes :id, :username, :user_email, :repository_name, :privacy, :description, :created_at, :updated_at

	    attribute :username do |object|
	      self.object.user.username
	    end

	    attribute :user_email do |object|
	      self.object.user.email
	    end
	  end
	end
end