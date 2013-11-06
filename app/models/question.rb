class Question < ActiveRecord::Base
  attr_accessible :body, :title

  validates_presence_of :body, :title, :user_id

  belongs_to :user
  has_many :answers
  has_many :comments, :as => :commentable
  has_many :votes, :as => :voteable
  has_many :edit_suggestions, :as => :editable

  def vote_counts
    votes = self.votes
    count = 0
    votes.each do |vote|
      (vote.direction == "up") ? (count += 1) : (count -= 1)
    end
    count
  end

  def vote_direction_by_user(id)
    self.votes.each do |vote|
      return vote.direction if vote.user_id == id
    end

    false
  end
end
