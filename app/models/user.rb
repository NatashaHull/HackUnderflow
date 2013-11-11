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

  has_many :questions, :order => "created_at DESC"
  has_many :answers, :order => "created_at DESC"
  has_many :comments, :order => "created_at DESC"
  has_many :votes, :order => "created_at DESC"
  has_many :edit_suggestions
  has_many :suggested_question_edits,
           :through => :questions,
           :source => :edit_suggestions,
           :order => "created_at DESC"
  has_many :suggested_answer_edits,
           :through => :answers,
           :source => :edit_suggestions,
           :order => "created_at DESC"

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
    questions = suggested_question_edits.reject(&:accepted)
    answers = suggested_answer_edits.reject(&:accepted)
    questions + answers
  end

  def pending_edit_suggestions
    self.edit_suggestions.reject(&:accepted)
  end

  def accepted_edit_suggestions
    self.edit_suggestions.select(&:accepted)
  end

  #Handle json rendering automatically
  def as_json(options={})
    all = options.delete(:all)
    if all
      json = super(build_all_json(options))
    else
      options, cu = build_user_json(options)
      json = revise_user_json(super(options), cu)
    end

    remove_private_attrs(json)
  end

  private

    #Validations
    def password_matches_confirmation
      unless @password == @password_confirmation
        errors[:password_confirmation] << "Password must match Password Confirmation"
      end
    end

    #JSON Stuff
    def build_all_json(options)
      options[:methods] ||= []
      options[:methods] << :gravatar_url
      options
    end

    def build_user_json(options)
      cu = options.delete(:cu)
      defaults = build_defaults(cu)
      options.merge!(defaults)
      [options, cu]
    end

    def build_defaults(cu)
      defaults = {
        :include => {
          :questions => {},
          :answers => { :methods => :question_title }
          },
        :methods => [:gravatar_url]
      }

      defaults
    end

    #Add attrs present on show page
    def revise_user_json(json, cu)
      json["accepted_edit_suggestions"] = self.accepted_edit_suggestions
      if cu && cu.id == self.id
        json["pending_edit_suggestions"] = self.pending_edit_suggestions
        json["suggested_edits"] = self.suggested_edits
      end
      json
    end

    def remove_private_attrs(json)
      json.delete("session_token")
      json.delete("password_digest")
      json
    end
end