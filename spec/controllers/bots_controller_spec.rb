require 'rails_helper'

describe BotsController do
  let(:current_user) { FactoryGirl.create(:user) }
  let(:authorized) { true }
  let(:params) { {
    bot: {
      name: 'foo',
      url: 'https://www.example.com/bots/foo',
      game: 'Thermonuclear War',
      active: 'true'
    }
  } }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(controller).to receive(:can?).and_return(authorized)
    allow(controller).to receive(:authorize!).and_return(authorized)
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

  describe '#create' do
    let(:bot) { Bot.new }

    before do
      allow(Bot).to receive(:new).and_return(bot)
      allow(bot).to receive(:save).and_return(valid_params)
      post :create, params
    end

    context 'with valid params' do
      let(:valid_params) { true }

      it 'assigns the bot to be created' do
        expect(assigns(:bot)).to be_a Bot
        expect(assigns(:bot).id).to eq bot.id
      end

      it 'redirects to the bot list' do
        expect(response).to redirect_to bots_path
      end
    end

    context 'with invalid params' do
      let(:valid_params) { false }

      it 'assigns the new bot' do
        expect(assigns(:bot)).to be_a Bot
        expect(assigns(:bot).id).to eq bot.id
      end

      it 'shows the edit page' do
        expect(response).to render_template(:new)
      end
    end
  end

  describe '#edit' do
    let(:bot) { FactoryGirl.create(:bot, user_id: current_user.id) }

    before do
      allow(Bot).to receive(:find).with(bot.id.to_s).and_return(bot)
      get :edit, id: bot.id
    end

    it "assigns the bot" do
      expect(assigns(:bot).id).to eq bot.id
    end

    it "is sucessful" do
      expect(response).to be_success
    end

    it "renders the edit bot page" do
      expect(response).to render_template(:edit)
    end
  end

  describe '#update' do
    let(:bot) { FactoryGirl.create(:bot) }

    before do
      allow(Bot).to receive(:find).with(bot.id.to_s).and_return(bot)
      allow(bot).to receive(:update_attributes).and_return(valid_params)
      put :update, params.merge(id: bot.id)
    end

    context 'with valid params' do
      let(:valid_params) { true }

      it 'assigns the new bot' do
        expect(assigns(:bot)).to be_a Bot
      end

      it 'redirects to the bot list' do
        expect(response).to redirect_to bots_path
      end
    end

    context 'with invalid params' do
      let(:valid_params) { false }

      it 'assigns the new bot' do
        expect(assigns(:bot)).to be_a Bot
      end

      it 'shows the edit page' do
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'unauthorized' do
    let(:authorized) { false }

    before do
      allow(controller).to receive(:authorize!).and_raise(CanCan::AccessDenied)
      allow(Bot).to receive(:find).and_return(double(:bot))
    end

    it 'redirects to the root path' do
      [
        [:get, :index],
        [:get, :new],
        [:post, :create, params],
        [:get, :edit, id: 42]
      ].each do |method, *args|
        self.send(method, *args)
        expect(response).to redirect_to root_path
        # expect(flash[:alert]).to eq I18n.t('botforge.alerts.unauthorized')
      end
    end
  end
end