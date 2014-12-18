require 'rails_helper'

RSpec.describe Chess, :type => :model do
  describe 'initial setup' do
    subject { Chess.create }

    it "sets the initial board layout" do
      expect(subject.board['current']).to eq Hash[
        'a' => {
          '1' => { 'piece' => 'R', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'R', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'b' => {
          '1' => { 'piece' => 'B', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'B', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'c' => {
          '1' => { 'piece' => 'Kn', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'Kn', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'd' => {
          '1' => { 'piece' => 'Q', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'Q', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'e' => {
          '1' => { 'piece' => 'K', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },      
          '7' => { 'piece' => 'K', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'f' => {
          '1' => { 'piece' => 'B', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'B', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'g' => {
          '1' => { 'piece' => 'Kn', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'Kn', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        },
        'h' => {
          '1' => { 'piece' => 'R', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'R', 'color' => 'B' },
          '8' => { 'piece' => 'P', 'color' => 'B' }
        }
      ]
    end

    it 'creates an empty move history' do
      expect(subject.board['history']).to eq []
    end
  end
end
