class Answer < ActiveRecord::Base
  attr_accessible :body, :question_id

  validates_presence_of :body, :question_id, :user_id
  validates_uniqueness_of :question_id, :scope => [:user_id]
  validate :only_one_accepted_answer

  belongs_to :user
  belongs_to :question
  has_many :comments, :as => :commentable
  has_many :votes, :as => :voteable
  has_many :edit_suggestions, :as => :editable

  def accept
    self.accepted = true
    self.save
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

  private

    def only_one_accepted_answer
      return nil unless self.accepted
      other_accepted_answers = Answer.find_by_sql([<<-SQL, self.id, self.question_id, true])
        SELECT *
        FROM answers
        WHERE answers.id = ?
          AND answers.question_id = ?
          AND answers.accepted = ?
      SQL
      if other_accepted_answers.length > 0
        errors[:answer] << "You cannot accept more than one answer!"
      end
    end
end
