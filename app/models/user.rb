class User < ActiveRecord::Base
  attr_accessible :password, :username
  # ensures that the username and password have correct length
  # and uniqueness
  validates :username, presence: true, uniqueness: true, length: {maximum: 128}
  validates :password, length: {maximum: 128}
  # creates a remember_token (used to keep track of session, based
  # on web tutorial) if none exist and also increments count before
  # each save
  before_save :create_remember_token, :increment_count

  private
  def create_remember_token
    self.remember_token ||= SecureRandom.urlsafe_base64
  end

  def increment_count
    self.count ||= 0
    self.count += 1
  end

end
