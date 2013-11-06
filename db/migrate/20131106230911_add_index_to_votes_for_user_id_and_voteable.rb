class AddIndexToVotesForUserIdAndVoteable < ActiveRecord::Migration
  def up
    add_index :votes, [:user_id, :voteable_id, :voteable_type], :unique => true
  end
end
