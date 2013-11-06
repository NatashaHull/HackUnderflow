class Answer < ActiveRecord::Base
  attr_accessible :body, :question_id

  validates_presence_of :body, :question_id, :user_id

  belongs_to :user
  belongs_to :question
  has_many :comments, :as => :commentable
  has_many :votes, :as => :voteable
end
