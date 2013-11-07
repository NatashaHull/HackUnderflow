class AddAcceptedColumnToEditSuggestions < ActiveRecord::Migration
  def up
    add_column :edit_suggestions, :accepted, :boolean, :default => false
  end

  def down
    remove_column :edit_suggestions, :accepted
  end
end
