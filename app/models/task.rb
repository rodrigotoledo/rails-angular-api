class Task < ApplicationRecord
  belongs_to :user

  validates :title, :description, presence: true
  validates_associated :user
end
