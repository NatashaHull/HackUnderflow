class CreateEditSuggestions < ActiveRecord::Migration
  def change
    create_table :edit_suggestions do |t|
      t.string :body
      t.integer :user_id
      t.integer :editable_id
      t.string :editable_type

      t.timestamps
    end

    add_index :edit_suggestions, :user_id
  end
end
