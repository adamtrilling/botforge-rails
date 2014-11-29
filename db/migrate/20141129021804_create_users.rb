class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :confirmation_token
      t.string :confirmed_at
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :confirmation_token
  end
end
