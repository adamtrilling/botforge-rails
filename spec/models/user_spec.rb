require 'rails_helper'

describe User do
  describe '#set_confirmation_token' do
    before do
      @user = FactoryGirl.create(:user)
      @token = @user.set_confirmation_token
    end

    it 'returns the confirmation token' do
      expect(@token).to_not be_nil
    end

    it 'encrypts the token in the database' do
      expect(@user.confirmation_token).to_not be_nil
      expect(@user.confirmation_token.to_s).to_not eq @token
    end
  end
end