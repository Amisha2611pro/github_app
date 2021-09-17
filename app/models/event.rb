class Event < ApplicationRecord
	belongs_to :repository
	belongs_to :user

	validates :event_type, presence: true, uniqueness: true
	validate :check_event_type

	def check_event_type
		if !["PushEvent","ReleaseEvent","WatchEvent"].include?(self.event_type)
			errors.add(:base, "please select a valid event")
		end
	end

end
