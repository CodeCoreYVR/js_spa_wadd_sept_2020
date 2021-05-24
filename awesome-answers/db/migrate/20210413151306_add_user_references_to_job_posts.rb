class AddUserReferencesToJobPosts < ActiveRecord::Migration[6.1]
  # To generate this migration:
  # rails g migration add_user_references_to_job_posts user:references
  def change
    add_reference :job_posts, :user, foreign_key: true
  end
end
