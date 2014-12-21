class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :type
      t.string :status
      t.jsonb :state
    end

    add_index :matches, :type
    add_index :matches, :status
    add_index :matches, :state, using: :gin

    create_table :participants do |t|
      t.references :match, index: true
      t.references :player, index: true
      t.integer :seat
      t.float :score
      t.integer :rank
    end

    add_index :participants, :seat
    add_index :participants, :score
    add_index :participants, :rank
  end
end
