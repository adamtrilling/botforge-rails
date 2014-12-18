require 'rails_helper'

RSpec.describe Participant, :type => :model do

  specify do
    should belong_to(:player)
    should belong_to(:match)

  end
end
