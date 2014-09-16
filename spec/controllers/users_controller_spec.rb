require 'rails_helper'

describe UsersController do
  describe '#new' do
    before do
      allow(controller).to receive(:check_session_token).and_return(logged_in?)
      get :new
    end

    context 'with a user who isn\'t logged in' do
      let(:logged_in?) { false }

      it "assigns a blank user" do
        expect(assigns(:user)).to be_a User
        expect(assigns(:user)).to_not be_persisted
      end

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