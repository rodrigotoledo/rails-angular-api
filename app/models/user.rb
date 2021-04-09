class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true
  validates :auth_token, uniqueness: true

  before_create :generate_auth_token!

  has_many :tasks, dependent: :destroy

  def generate_auth_token!
    begin
      self.auth_token = Devise.friendly_token
    end while User.exists?(auth_token: self.auth_token)
  end
end
