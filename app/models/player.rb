class Player < ActiveRecord::Base
  belongs_to :user
  has_many :participants

  validates :game,
    presence: true
end
