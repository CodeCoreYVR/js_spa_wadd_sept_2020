class CreateAnswers < ActiveRecord::Migration[6.1]
  # This file was generated with:
  # rails g model answer body:text question:references
  # Database indexing is added by "question:references". It is a
  # data structure that the database uses to speed up data retrieval.
  def change
    create_table :answers do |t|
      t.text :body

      # This creates a "question_id" column of type "big_int". 
      # It also sets a foreign_key constraint to enforce the 
      # association to the questions table at the database level.
      # The "question_id" field will refer to the primary key of 
      # the question that the answer is associated to. It is said
      # that the answer "belongs_to" the question.
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
