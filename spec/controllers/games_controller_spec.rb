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
end