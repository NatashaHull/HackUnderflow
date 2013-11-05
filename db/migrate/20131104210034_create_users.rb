class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :null => false
      t.string :password_digest, :null => false
      t.string :session_token, :null => false
      t.integer :points, :default => 5

      t.timestamps
    end
    
    add_index :users, :username, :unique => true
    add_index :users, :session_token
  end
end
