require 'rails_helper'

describe MatchesController do
  let(:current_user) { FactoryGirl.create(:user) }

  describe '#create' do
    before do
      allow(controller).to receive(:current_user).and_return(current_user)
      post :create, game: game
    end

    context 'with a valid game' do
      let(:game) { 'Chess' }

      it 'assigns a new match with the current user as a participant' do
        expect(assigns(:match)).to be_a Chess
        expect(assigns(:match)).to be_persisted
        expect(assigns(:match).participants.first.player.user.id).to eq current_user.id
      end

      it 'redirects to the match' do
        expect(response).to redirect_to match_path(assigns(:match))
      end
    end

    context 'with an invalid game' do
      let(:game) { 'thermonuclear_war' }

      it 'redirects to the games index' do
        expect(response).to redirect_to games_path
      end
    end
  end
end