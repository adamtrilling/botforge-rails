require 'rails_helper'

RSpec.describe Player, :type => :model do
  specify do
    should belong_to(:user)
    should validate_presence_of(:game)
  end
end
