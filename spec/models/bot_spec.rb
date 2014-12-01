require 'rails_helper'

RSpec.describe Bot, :type => :model do


  specify do
    should belong_to(:user)
    should validate_presence_of(:game)
    should validate_presence_of(:url)
  end

  describe '#url' do
    it 'allows valid urls' do
      should allow_value('http://foo.com', 'https://foo.com/bar').
        for(:url)
      should_not allow_value('ftp://foo.com', 'foo.bar/baz', 'abc@example.com').
        for(:url)
    end
  end
end
