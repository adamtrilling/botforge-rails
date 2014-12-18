require 'rails_helper'

RSpec.describe Match, :type => :model do

  specify do
    should have_many(:participants)

    should validate_inclusion_of(:type).in_array(Match::GAMES.keys)
  end
end
