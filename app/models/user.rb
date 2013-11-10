require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation
  attr_reader :password
  attr_accessor :password_confirmation
  extend FriendlyId
  
  friendly_id :username, :use => :slugged

  validates_presence_of :username, :email, :password_digest, :session_token
  validates :username, :email, :uniqueness => true
  validates :password, :length => { :minimum => 6, :allow_nil => true }
  validate :password_matches_confirmation

  has_many :questions
  has_many :answers
  has_many :comments
  has_many :votes
  has_many :edit_suggestions
  has_many :sugggested_question_edits,
           :through => :questions,
           :source => :edit_suggestions
  has_many :sugggested_answer_edits,
           :through => :answers,
           :source => :edit_suggestions

  def self.find_by_credentials(user_params)
    user = User.find_by_username(user_params[:username])
    user ||= User.find_by_email(user_params[:username])
    return user if user.is_password?(user_params[:password])
  end

  #Email stuff
  def gravatar_url
    gravatar_id = Digest::MD5::hexdigest(self.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}"
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

  #Edit Suggestion Compilation
  def suggested_edits
    questions = sugggested_question_edits.includes(:editable).where(:accepted => false)
    answers = sugggested_answer_edits.includes(:editable).where(:accepted => false)
    questions + answers
  end

  def pending_edit_suggestions
    self.edit_suggestions.where(:accepted => false)
  end

  def accepted_edit_suggestions
    self.edit_suggestions.where(:accepted => true)
  end

  #Making json rendering uniform
  def as_json(options={})
    cu_bool = options.delete(:is_current_user)
    defaults = build_defaults(cu_bool)

    options.merge!(defaults)
    json = super(options)
    json.delete("session_token")
    json.delete("password_digest")
    json
  end

  private

    def password_matches_confirmation
      unless @password == @password_confirmation
        errors[:password_confirmation] << "Password must match Password Confirmation"
      end
    end

    def build_defaults(cu_bool)
      preload_user_info(cu_bool)

      defaults = {:include => [:questions, :answers],
                  :methods => [:accepted_edit_suggestions]}

      if cu_bool
        defaults[:methods] << :pending_edit_suggestions
        defaults[:methods] << :suggested_edits
        defaults[:methods] << :gravatar_url
      end
      defaults
    end

    def preload_user_info(cu_bool)
      User.transaction do
        self.questions
        self.answers
        self.edit_suggestions
        
        #Only load these things if it's this is the current user
        if cu_bool
          self.sugggested_question_edits
          self.sugggested_answer_edits         
        end
      end
    end
end