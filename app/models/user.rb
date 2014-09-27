class User < BaseModel
  attribute :username
  attribute :email
  attribute :password

  validates_confirmation_of :password
end