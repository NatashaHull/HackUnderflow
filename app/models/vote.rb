class Vote < ActiveRecord::Base
  validates_presence_of :direction, :user_id, :voteable_id,
                        :voteable_type
  validates :direction, :inclusion => { :in => ["up", "down"] }

  belongs_to :voteable, :polymorphic => true
  belongs_to :user
end