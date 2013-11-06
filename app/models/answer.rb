class Answer < ActiveRecord::Base
  attr_accessible :body, :question_id

  validates_presence_of :body, :question_id, :user_id

  belongs_to :user
  belongs_to :question
  has_many :comments, :as => :commentable
  has_many :votes, :as => :voteable

  def vote_counts
    votes = self.votes
    count = 0
    votes.each do |vote|
      (vote.direction == "up") ? (count += 1) : (count -= 1)
    end
    count
  end
end
