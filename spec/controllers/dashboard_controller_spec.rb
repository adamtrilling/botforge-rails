require 'rails_helper'

describe DashboardController do
  describe '#index' do
    before do
      get :index
    end

    it 'is successful' do
      expect(response).to be_success
    end

    it 'renders the dashboard' do
      expect(response).to render_template(:index)
    end
  end
end