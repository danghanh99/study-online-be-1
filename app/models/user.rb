class User < ApplicationRecord
  has_and_belongs_to_many :groups
  belongs_to :job, required: false
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
  format: { with: VALID_EMAIL_REGEX },
  uniqueness: { case_sensitive: false }
  PASSWORD_FORMAT = /\A(?!.*\s)/x.freeze
  validates :password, presence: true, length: { in: 6..40 }, format: { with: PASSWORD_FORMAT }
end
