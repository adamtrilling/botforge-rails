require 'rails_helper'

describe UsersController do
  describe '#new' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      get :new
    end

    context 'with a user who isn\'t logged in' do
      let(:user) { nil }

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
      let(:user) { FactoryGirl.create(:user) }

      it "redirects to the dashboard" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#create' do
    before do
      allow(controller).to receive(:current_user).and_return(logged_in_user)

      @user = User.new
      allow(User).to receive(:new).and_return(@user)
      allow(@user).to receive(:save).and_return(valid_params?)
      allow(UserMailer).to receive_message_chain(:confirmation, :deliver_now)

      post :create, { 'user' => { 'foo' => 'bar' } }
    end

    context 'with a user who is logged in' do
      let(:logged_in_user) { @user }
      let(:valid_params?) { true }

      it 'saves the user' do
        expect(@user).to have_received(:save)
      end

      context 'with valid params' do
        it 'sends a confirmation email' do
          expect(UserMailer).to have_received(:confirmation)
        end

        it 'redirects to the dashboard' do
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
      let(:logged_in_user) { nil }

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

  describe '#confirm' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      allow(User).to receive(:find).with(user.id.to_s).and_return(user)
      allow(user).to receive(:verify_confirmation_token).and_return(valid_token?)
    
      get :confirm, id: user.id, token: 'tokentokentoken'
    end

    context "with the correct token" do
      let(:valid_token?) { true }

      it "redirects to the user's profile" do
        expect(response).to redirect_to user_path(user)
      end

      it "confirms the user" do
        expect(user.confirmed_at).to_not be_nil
        expect(user.confirmation_token).to be_nil
      end
    end

    context "with the wrong token" do
      let(:valid_token?) { false }

      it "redirects to the root" do
        expect(response).to redirect_to root_path
      end

      it "does not confirm the user" do
        expect(user.confirmed_at).to be_nil
      end
    end
  end

  describe '#show' do
    context 'with a user that exists' do

      let(:user) { FactoryGirl.create(:user) }

      before do
        allow(User).to receive(:find).with(user.id.to_s).and_return(user)
        get :show, id: user.id
      end

      it 'is successful' do
        expect(response).to be_success
      end

      it 'renders the show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'with a user that doesn\'t exist' do
      before do
        get :show, id: -42
      end

      it 'returns not found' do
        expect(response).to be_not_found
      end
    end
  end
end