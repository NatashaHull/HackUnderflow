class Comment < ActiveRecord::Base
  attr_accessible :body

  validates_presence_of :body, :user_id, :commentable_id, :commentable_type

  belongs_to :commentable, :polymorphic => true
  belongs_to :user
end
