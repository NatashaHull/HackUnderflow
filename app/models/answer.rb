class Answer < ActiveRecord::Base
  attr_accessible :body, :question_id

  validates_presence_of :body, :question_id, :user_id
  validates_uniqueness_of :question_id, :scope => [:user_id]
  validate :only_one_accepted_answer, :not_question_owner

  belongs_to :user
  belongs_to :question
  has_many :comments, :as => :commentable
  has_many :votes, :as => :voteable
  has_many :edit_suggestions, :as => :editable

  def accept
    ActiveRecord::Base.transaction do
      self.accepted = true
      self.save
      self.user.add_points(15)
    end
  end

  #Question Stuff
  def question_title
    self.question.title
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

  def contributors
    User.find_by_sql([<<-SQL, self.id, "Answer", true])
      SELECT users.*
      FROM users
        INNER JOIN edit_suggestions
          ON edit_suggestions.user_id = users.id
      WHERE edit_suggestions.editable_id = ?
        AND edit_suggestions.editable_type = ?
        AND edit_suggestions.accepted = ?
    SQL
  end

  #API Stuff
  def as_json(options={})
    options[:include] = [:comments]
    options[:methods] = [:vote_counts]
    super(options)
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

    def not_question_owner
      question_obj = Question.find(self.question_id)

      if question_obj.user_id == self.user_id
        errors[:user] << "You can't answer your own question"
      end
    end
end
