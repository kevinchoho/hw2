class Actor < ApplicationRecord
  belongs_to :agent
  has_many :roles
  has_many :movies, through: :roles
end
