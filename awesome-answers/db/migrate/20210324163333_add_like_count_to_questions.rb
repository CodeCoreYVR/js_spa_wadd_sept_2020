class AddLikeCountToQuestions < ActiveRecord::Migration[6.1]
  # This migration file was generated with:
  # rails g migration add_like_count_to_questions like_count:integer
  def change
    add_column :questions, :like_count, :integer
  end
end
