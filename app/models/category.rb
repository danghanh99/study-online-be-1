class Category < ApplicationRecord
  has_many :groups
  validates :name, presence: true, uniqueness: true, length: { in: 2..40 }
end
