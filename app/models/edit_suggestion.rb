class EditSuggestion < ActiveRecord::Base
  attr_accessible :body

  validates_presence_of :body, :editable_id, :editable_type, :user_id

  belongs_to :editable, :polymorphic => true
  belongs_to :user

  def accept_edit
    self.editable.body = self.body
    self.editable.save!
    self.destroy
  end

  def question
    if self.editable_type == "Question"
      self.editable
    else
      self.editable.question
    end
  end
end
