class Vote < ActiveRecord::Base
  # before_validation :cleanup_old_votes
  validates_presence_of :direction, :user_id, :voteable_id,
                        :voteable_type
  validates_uniqueness_of :voteable_id,
                          :scope => [:voteable_type, :user_id]
  validates :direction, :inclusion => { :in => ["up", "down"] }

  belongs_to :voteable, :polymorphic => true
  belongs_to :user

  private

    def cleanup_old_votes
      old_vote = Vote.find_by_user_id_and_voteable_id_and_voteable_type(
        self.user_id,
        self.voteable_id,
        self.voteable_type
        )

      unless old_vote.direction == self.direction
        old_vote.destroy
      end
    end
end