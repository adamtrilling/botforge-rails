require 'rails_helper'

describe SessionsController do
  describe '#new' do
    before do
      allow(controller).to receive(:check_session_token).and_return(logged_in?)
      get :new
    end

    context 'with a user who isn\'t logged in' do
      let(:logged_in?) { false }

      it "is sucessful" do
        expect(response).to be_success
      end

      it "renders the login page" do
        expect(response).to render_template(:new)
      end
    end

    context 'with a user who is logged in' do
      let(:logged_in?) { true }

      it "redirects to the dashboard" do
        expect(response).to redirect_to root_path
      end
    end
  end
end