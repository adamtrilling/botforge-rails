require 'rails_helper'

describe SessionsController do
  describe '#new' do
    context 'with a user who isn\'t logged in' do
      before do
        session[:user_id] = nil
        session[:session_token] = nil
        
        get :new
      end

      it "is sucessful" do
        expect(response).to be_success
      end

      it "renders the login page" do
        expect(response).to render_template(:new)
      end
    end

    context 'with a user who is logged in' do
      let(:user_id) { rand(10000) }
      let(:session_token) { rand(10000) }

      before do
        session[:user_id] = user_id
        session[:session_token] = session_token

        get :new
      end

      it "redirects to the dashboard" do
        expect(response).to redirect_to dashboard_path
      end
    end
  end
end