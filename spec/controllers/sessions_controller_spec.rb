require 'rails_helper'

describe SessionsController do
  describe '#new' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      get :new
    end

    context 'with a user who isn\'t logged in' do
      let(:user) { nil }

      it "is sucessful" do
        expect(response).to be_success
      end

      it "renders the login page" do
        expect(response).to render_template(:new)
      end
    end

    context 'with a user who is logged in' do
      let(:user) { FactoryGirl.create(:user) }

      it "redirects to the dashboard" do
        expect(response).to redirect_to root_path
      end
    end
  end
end