class Question < ActiveRecord::Base
  attr_accessible :body, :title

  validates_presence_of :body, :title, :user_id

  belongs_to :user
  has_many :answers
  has_many :comments, :as => :commentable
  has_many :votes, :as => :voteable
  has_many :edit_suggestions, :as => :editable

  paginates_per 15

  #Answer Stuff
  def accepted_answer
    self.answers.each do |answer|
      return answer if answer.accepted == true
    end
    false
  end

  #Vote Stuff
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

  #Edit stuff
  def contributors
    User.find_by_sql([<<-SQL, self.id, "Question", true])
      SELECT users.*
      FROM users
        INNER JOIN edit_suggestions
          ON edit_suggestions.user_id = user.id
      WHERE edit_suggestions.editable_id = ?
        AND edit_suggestions.editable_type = ?
        AND edit_suggestions.accepted = ?
    SQL
  end

  def as_json(options={})
    json = {}
    json[:model] = super(options)
    json[:model]["answers"] = self.answers
    json[:model]["vote_counts"] = self.vote_counts
    json[:model]["comments"] = self.comments
    json[:model]["accepted_answer"] = self.accepted_answer
    json
  end
end
