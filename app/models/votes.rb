class Votes < ActiveRecord::Base
  validates_presence_of :direction, :user_id, :voteable_id,
                        :voteable_type

  belongs_to :voteable, :polymorphic => true
  belongs_to :user
end
