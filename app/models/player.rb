class Player < ActiveRecord::Base
  belongs_to :user

  validates :game,
    presence: true
end
