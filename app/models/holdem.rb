class Holdem < Match
  def self.expected_participants
    { min: 2, max: 10 }
  end
end