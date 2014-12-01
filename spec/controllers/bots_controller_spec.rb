require 'rails_helper'

describe BotsController do
  let(:current_user) { FactoryGirl.create(:user) }

  before do
    controller.stub(:current_user).and_return(current_user)
  end

  describe '#new' do
    before do
      allow(controller).to receive(:current_user).and_return(current_user)
      get :new
    end

    context 'with a user who is logged in' do
      let(:user) { FactoryGirl.create(:user) }

      it "assigns a blank user" do
        expect(assigns(:user)).to be_a User
        expect(assigns(:user)).to_not be_persisted
      end

      it "is sucessful" do
        expect(response).to be_success
      end

      it "renders the new bot page" do
        expect(response).to render_template(:new)
      end
    end

    context 'with a user who is not logged in' do
      let(:user) { nil }

      it "redirects to the dashboard" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'unauthorized' do
    before do
      controller.stub(:can?).with(:manage, Bot).and_return(false)
    end

    it 'redirects to the root path' do
      [
        [:get, :new]
      ].each do |method, *args|
        self.send(method, *args)
        expect(response).to redirect_to root_path
        # expect(flash[:alert]).to eq I18n.t('botforge.alerts.unauthorized')
      end
    end
  end
end