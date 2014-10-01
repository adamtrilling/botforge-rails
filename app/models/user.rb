class User < BaseModel
  attribute :username
  attribute :email
  attribute :password
  attribute :confirmation_token
  attribute :confirmed_at

  validates_confirmation_of :password

  def set_confirmation_token
    token = SecureRandom.hex
    self.confirmation_token = BCrypt::Password.create(token)
    save
    token
  end

  def verify_confirmation_token(token)
    BCrypt::Password.new(confirmation_token) == token
  end
end