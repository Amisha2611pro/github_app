class Event < ApplicationRecord
	belongs_to :repository
	belongs_to :user

	validates :event_type, presence: true, uniqueness: true
end
