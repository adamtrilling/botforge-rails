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

  describe '#create' do
    let(:user) { FactoryGirl.create(:user) }

    before do
      allow(User).to receive(:where).with("username = ? OR email = ?", user.email, user.email).and_return([user])
      allow(user).to receive(:authenticate).with('password').and_return(correct_password?)
      allow(controller).to receive(:current_user).and_return(logged_in_user)
      
      post :create, session: { username: user.email, password: 'password' }
    end

    context 'when not logged in' do
      let(:logged_in_user) { nil }

      context 'with the correct password' do
        let(:correct_password?) { true }

        it 'logs the user in' do
          expect(session[:user_id]).to eq user.id
        end

        it 'redirects to the dashboard' do
          expect(response).to redirect_to root_path
        end
      end

      context 'with the wrong password' do
        let(:correct_password?) { false }

        it 'does not log the user in' do
          expect(session[:user_id]).to be_nil
        end

        it 'renders the login page' do
          expect(response).to render_template(:new)
        end
      end
    end

    context 'when already logged in' do
      let(:correct_password?) { true }
      let(:logged_in_user) { user }

      it 'redirects to the dashboard' do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#destroy' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
      delete :destroy
    end

    context 'with a user who isn\'t logged in' do
      let(:user) { nil }

      it 'redirects to the login page' do
        expect(response).to redirect_to new_session_path
      end
    end

    context 'with a user who is logged in' do
      let(:user) { FactoryGirl.create(:user) }

      it 'logs the user out' do
        expect(session[:user_id]).to be_nil
      end

      it 'redirects to the login page' do
        expect(response).to redirect_to new_session_path
      end
    end
  end
end