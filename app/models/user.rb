class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :token_authenticatable

  has_many :authentication_tokens, dependent: :destroy
  has_many :repositories, dependent: :destroy
  
  validates :username, presence: true
  validates :username, format: { without: /\s/, message: "must contain no spaces" }
  
end
