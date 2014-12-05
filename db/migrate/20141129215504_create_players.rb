class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :type
      t.references :user, index: true

      t.string :name
      t.string :url, null: false
      t.string :game, null: false
      t.float :rating, default: 2000.0

      t.boolean :active, default: true
      t.integer :warnings, default: 0

      t.timestamps null: false
    end

    add_index :players, :active
    add_index :players, :game
  end
end
