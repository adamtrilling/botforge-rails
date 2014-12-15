require 'rails_helper'

RSpec.describe Match, :type => :model do

  specify do
    should have_many(:participants)

    should validate_presence_of(:game)
  end
end
