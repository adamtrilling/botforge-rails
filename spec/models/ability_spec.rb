require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  subject { Ability.new(user) }

  describe 'logged in' do
    let(:user) { FactoryGirl.create(:user) }
    let(:other_user) { FactoryGirl.create(:user) }

    let(:my_bot) { FactoryGirl.create(:bot, user: user) }
    let(:their_bot) { FactoryGirl.create(:bot, user: other_user) }

    specify do
      should be_able_to :manage, my_bot
      should_not be_able_to :manage, their_bot
    end
  end

  describe 'logged out' do
    let(:user) { nil }

    specify do
      should_not be_able_to :manage, Bot
    end
  end
end