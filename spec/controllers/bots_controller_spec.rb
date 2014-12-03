require 'rails_helper'

describe BotsController do
  let(:current_user) { FactoryGirl.create(:user) }
  let(:authorized) { true }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(controller).to receive(:can?).and_return(authorized)
  end

  describe '#index' do
    let!(:bots) {[
      FactoryGirl.create(:bot, user: current_user),
      FactoryGirl.create(:bot, user: current_user)
    ]}

    before do
      get :index
    end

    it 'assigns the current user\'s bots' do
      expect(assigns(:bots).size).to eq bots.size
      bots.each do |b|
        expect(assigns(:bots).collect(&:id)).to include(b.id)
      end
    end

    it "is sucessful" do
      expect(response).to be_success
    end

    it "renders the bot index" do
      expect(response).to render_template(:index)
    end
  end

  describe '#new' do
    before do
      get :new
    end

    it "assigns a blank bot assigned to the current user" do
      expect(assigns(:bot)).to be_a Bot
      expect(assigns(:bot)).to_not be_persisted
      expect(assigns(:bot).user_id).to eq current_user.id
    end

    it "is sucessful" do
      expect(response).to be_success
    end

    it "renders the new bot page" do
      expect(response).to render_template(:new)
    end
  end

  describe 'unauthorized' do
    let(:authorized) { false }

    it 'redirects to the root path' do
      [
        [:get, :index],
        [:get, :new]
      ].each do |method, *args|
        self.send(method, *args)
        expect(response).to redirect_to root_path
        # expect(flash[:alert]).to eq I18n.t('botforge.alerts.unauthorized')
      end
    end
  end
end