class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP}
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, :confirmation => true, length: { minimum: 7 }, :if => :password
end
