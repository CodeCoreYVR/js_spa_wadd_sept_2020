class Answer < ApplicationRecord
  # Rails guides associations: https://guides.rubyonrails.org/association_basics.html
  
  # "belongs_to" will create a validation that looks like this:
  # validates :question_id, presence: true
  # It can be disabled by passing the option "optional: true" to
  # the belongs_to method e.g. belongs_to :question, optional: true

  # In an assocation between two models, the model that has the 
  # "belongs_to" method is the table that conatins the foreign_key
  # e.g. question_id.

  # The line below was added automatically when we generated this 
  # model with an association.
  belongs_to :question
  belongs_to :user

  # With "belongs_to", the following instance methods are added to 
  # the Answer model. These simplify interactions with the associated question.

  # question
  # question=(associate)
  # build_question(attributes = {})
  # create_question(attributes = {})
  # create_question!(attributes = {})
  # reload_question

  has_many :donations

  validates :body, presence: true
end
