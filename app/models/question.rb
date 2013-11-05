class Question < ActiveRecord::Base
  attr_accessible :body, :title

  validates_presence_of :body, :title, :user_id

  belongs_to :user
  has_many :answers
  has_many :comments, :as => :commentable
end
