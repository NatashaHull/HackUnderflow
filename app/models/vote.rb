class Vote < ActiveRecord::Base
  validates_presence_of :direction, :user_id, :voteable_id,
                        :voteable_type
  validates_uniqueness_of :voteable_id,
                          :scope => [:voteable_type, :user_id]
  validates :direction, :inclusion => { :in => ["up", "down"] }

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
        build_vote(dir, v_id, v_type, u_id)
        calculate_user_points(dir, v_type, u_id)
      elsif old_vote.direction == dir
        old_vote.destroy
      else
        old_vote.direction = dir
        old_vote.save!
        calculate_user_points(dir, v_type, u_id)
      end
    end
  end

  def self.build_vote(dir, v_id, v_type, u_id)
    vote = Vote.new
    vote.direction = dir
    vote.voteable_id = v_id
    vote.voteable_type = v_type
    vote.user_id = u_id
    vote.save!
  end

  def self.calculate_user_points(dir, v_type, u_id)
    return unless dir == "up"
    if v_type == "Question"
      User.find(u_id).add_points(5)
    else
      User.find(u_id).add_points(10)
    end
  end
end