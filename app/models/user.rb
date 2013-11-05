class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation
  attr_reader :password
  attr_accessor :password_confirmation

  before_validation :set_session_token
  validates_presence_of :username, :password_digest, :session_token
  validates :username, :uniqueness => true
  validates :password, :length => { :minimum => 6, :allow_nil => true }
  validate :password_matches_confirmation

  has_many :questions
  has_many :answers

  def self.find_by_credentials(user_params)
    user = User.find_by_username(user_params[:username])
    return user if user.is_password?(user_params[:password])
  end

  #Password Stuff
  def password=(raw_pass)
    @password = raw_pass
    self.password_digest = BCrypt::Password.create(raw_pass)
  end

  def is_password?(pass)
    p = BCrypt::Password.new(self.password_digest)
    p.is_password?(pass)
  end

  #Session Token Stuff
  def reset_session_token!
    set_session_token
    self.save!
    self.session_token
  end

  def set_session_token
    self.session_token = SecureRandom.urlsafe_base64(16)
  end

  #Points Stuff
  def add_points(num)
    self.points += num
    self.save!
  end

  def can_vote_up?
    self.points >= 15
  end

  def can_comment?
    self.points >= 50
  end

  def can_vote_down?
    self.points >= 125
  end

  def can_edit?
    self.points >= 2000
  end

  private

    def password_matches_confirmation
      unless @password == @password_confirmation
        errors[:password_confirmation] << "Password must match Password Confirmation"
      end
    end
end