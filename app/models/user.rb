class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true
  validates :auth_token, uniqueness: true

  before_create :generate_auth_token!

  def generate_auth_token!
    begin
      self.auth_token = Devise.friendly_token
    end while User.exists?(auth_token: self.auth_token)
  end
end
