class Repository < ApplicationRecord
	has_many :events, dependent: :destroy
  belongs_to :user

  validates :repository_name, presence: true, uniqueness: true

  def public!
	  self.privacy = false
	end

	def private!
	  self.privacy = true
	end
end
