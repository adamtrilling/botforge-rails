require 'rails_helper'

describe GamesController do
  describe '#index' do
    before do
      get :index
    end

    it 'is successful' do
      expect(response).to be_success
    end

    it 'renders the games list' do
      expect(response).to render_template(:index)
    end
  end

  describe '#show' do
    before do
      allow(Match::GAMES).to receive(:has_key?).and_return(valid_game)
      get :show, id: 'thermonuclear_war'
    end

    context 'with a valid game' do
      let(:valid_game) { true }

      it 'is successful' do
        expect(response).to be_success
      end

      it 'renders the game page' do
        expect(response).to render_template(:show)
      end
    end

    context 'with an invalid game' do
      let(:valid_game) { false }

      it 'is not found' do
        expect(response.status).to eq 404
      end
    end
  end
end