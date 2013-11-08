class AddSlugsColumnToUsers < ActiveRecord::Migration
  def up
    add_column :users, :slug, :string
    add_index :users, :slug, :unique => true
  end
end
