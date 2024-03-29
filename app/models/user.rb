class User < ActiveRecord::Base

  has_many :bots
  has_many :humans

  has_secure_password validations: false

  def set_confirmation_token
    token = SecureRandom.hex
    self.confirmation_token = BCrypt::Password.create(token)
    token
  end

  def verify_confirmation_token(token)
    BCrypt::Password.new(self.confirmation_token) == token
  end

  def human_for(game)
    humans.find_or_create_by(game: game)
  end
end