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

  describe '#create' do
    before do
      allow(controller).to receive(:check_session_token).and_return(logged_in?)

      @user = User.new
      allow(User).to receive(:new).and_return(@user)
      allow(@user).to receive(:save).and_return(valid_params?)

      post :create, { 'user' => { 'foo' => 'bar' } }
    end

    context 'with a user who is logged in' do
      let(:logged_in?) { true }
      let(:valid_params?) { true }

      it "saves the user" do
        expect(@user).to have_received(:save)
      end

      context "with valid params" do
        it "redirects to the dashboard" do
          expect(response).to redirect_to root_path
        end
      end

      context "with invalid params" do
        let(:valid_params?) { false }

        it "renders the registration page" do
          expect(response).to render_template(:new)
        end
      end
    end

    context 'with a user who isn\'t logged in' do
      let(:valid_params?) { false }
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
  end
end