class RemoveLikeCountFromQuestions < ActiveRecord::Migration[6.1]
  # This migration file was generated with:
  # rails g migration remove_like_count_from_questions like_count:integer
  def change
    remove_column :questions, :like_count, :integer
  end
end
