require 'rails_helper'

RSpec.describe Chess, :type => :model do
  describe 'initial setup' do
    subject { Chess.create }

    it "sets the initial board layout" do
      expect(subject.board['current']).to eq Hash[
        'a' => {
          '1' => { 'piece' => 'R', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'R', 'color' => 'B' }
        },
        'b' => {
          '1' => { 'piece' => 'B', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'B', 'color' => 'B' }
        },
        'c' => {
          '1' => { 'piece' => 'Kn', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'Kn', 'color' => 'B' }
        },
        'd' => {
          '1' => { 'piece' => 'Q', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'Q', 'color' => 'B' }
        },
        'e' => {
          '1' => { 'piece' => 'K', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'K', 'color' => 'B' }
        },
        'f' => {
          '1' => { 'piece' => 'B', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'B', 'color' => 'B' }
        },
        'g' => {
          '1' => { 'piece' => 'Kn', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'Kn', 'color' => 'B' }
        },
        'h' => {
          '1' => { 'piece' => 'R', 'color' => 'W' },
          '2' => { 'piece' => 'P', 'color' => 'W' },
          '7' => { 'piece' => 'P', 'color' => 'B' },
          '8' => { 'piece' => 'R', 'color' => 'B' }
        }
      ]
    end

    it 'creates an empty move history' do
      expect(subject.board['history']).to eq []
    end
  end
end
