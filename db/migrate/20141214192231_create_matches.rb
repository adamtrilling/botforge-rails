class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :type
      t.string :state
      t.integer :next_to_move
      t.jsonb :board
    end

    add_index :matches, :type
    add_index :matches, :state
    add_index :matches, :next_to_move
    add_index :matches, :board, using: :gin

    create_table :participants do |t|
      t.references :match, index: true
      t.references :player, index: true
      t.integer :starting_seat
      t.integer :seat
      t.float :score
      t.integer :rank
    end

    add_index :participants, :starting_seat
    add_index :participants, :seat
    add_index :participants, :score
    add_index :participants, :rank
  end
end
