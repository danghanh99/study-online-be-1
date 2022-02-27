class Job < ApplicationRecord
  has_many :users
  validates :name, presence: true, uniqueness: true, length: { in: 2..40 }
end
