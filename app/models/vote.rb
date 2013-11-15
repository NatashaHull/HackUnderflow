class Vote < ActiveRecord::Base
  validates_presence_of :direction, :user_id, :voteable_id,
                        :voteable_type
  validates_uniqueness_of :voteable_id,
                          :scope => [:voteable_type, :user_id]
  validates :direction, :inclusion => { :in => ["up", "down"] }
  validate :user_not_voteable_owner

  belongs_to :voteable, :polymorphic => true
  belongs_to :user

  def self.parse_vote_request(dir, v_id, v_type, u_id)
    ActiveRecord::Base.transaction do
      old_vote = Vote.find_by_user_id_and_voteable_id_and_voteable_type(
        u_id,
        v_id,
        v_type
        )

      if !old_vote
        calculate_user_points(dir, v_id, v_type)
        old_vote = build_vote(dir, v_id, v_type, u_id)
      elsif old_vote.direction == dir
        old_vote.destroy
      else
        calculate_user_points(dir, v_id, v_type)
        old_vote.direction = dir
        old_vote.save!
      end
      old_vote
    end
  end

  def self.build_vote(dir, v_id, v_type, u_id)
    vote = Vote.new
    vote.direction = dir
    vote.voteable_id = v_id
    vote.voteable_type = v_type
    vote.user_id = u_id
    vote.save!
    vote
  end

  def self.calculate_user_points(dir, v_id, v_type)
    return unless dir == "up"
    if v_type == "Question"
      Question.find(v_id).user.add_points(5)
    else
      Answer.find(v_id).user.add_points(10)
    end
  end

  private

    def user_not_voteable_owner
      if self.voteable_type == "Question"
        voteable_obj = get_question
      else
        voteable_obj = get_answer
      end

      if voteable_obj.user_id == self.user_id
        errors[:user] << "You cannot vote on your own post"
      end
    end

    def get_question
      Question.find(self.voteable_id)
    end

    def get_answer
      Answer.find(self.voteable_id)
    end
end