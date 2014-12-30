require 'rails_helper'

describe MatchesController do
  let(:current_user) { FactoryGirl.create(:user) }

  describe '#create' do
    before do
      allow(controller).to receive(:current_user).and_return(current_user)
      post :create, game: game
    end

    context 'with a valid game' do
      Match::GAMES.keys.each do |g|
        context g do
          let(:game) { g }

          it 'assigns a new match with the current user as a participant' do
            expect(assigns(:match)).to be_a g.constantize
            expect(assigns(:match)).to be_persisted
            expect(assigns(:match).has_participants?).to eq true
            expect(assigns(:match).participants.first.player.user.id).to eq current_user.id
          end

          it 'starts the match' do
            expect(assigns(:match).state).to_not be_nil
          end

          it 'redirects to the match' do
            expect(response).to redirect_to match_path(assigns(:match))
          end
        end
      end
    end

    context 'with an invalid game' do
      let(:game) { 'thermonuclear_war' }

      it 'redirects to the games index' do
        expect(response).to redirect_to games_path
      end
    end
  end

  describe '#show' do
    Match::GAMES.keys.each do |g|
      context g do
        context 'with a match that exists' do
          let(:match) { FactoryGirl.create(g.downcase.to_sym) }

          before do
            allow(Match).to receive(:find).with(match.id.to_s).and_return(match)
            get :show, id: match.id
          end

          it 'assigns the match' do
            expect(assigns(:match).id).to eq match.id
          end

          it 'renders the templates for the correct game' do
            expect(response).to render_template(:show)
          end
        end

        context 'with a match that doesn\'t exist' do
          before do
            allow(Match).to receive(:find).with('-42').and_raise(ActiveRecord::RecordNotFound)
            get :show, id: '-42'
          end

          it 'returns 404' do
            expect(response.status).to eq 404
          end
        end
      end
    end
  end
end