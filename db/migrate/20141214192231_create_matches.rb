class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :type
      t.string :state
      t.jsonb :board
    end

    create_table :participants do |t|
      t.references :match, index: true
      t.references :player, index: true
    end
  end
end
