class Bot < Player
  validates :url,
    presence: true,
    url: true
end