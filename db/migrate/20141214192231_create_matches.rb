class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :type
      t.string :state
      t.json :board
    end

    create_table :seats do |t|
      t.reference :match, index: true
      t.reference :player, index: true
    end
  end
end
