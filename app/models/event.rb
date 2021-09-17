class Event < ApplicationRecord
	belongs_to :repository
	
	validates :event_type, presence: true, uniqueness: true
end
