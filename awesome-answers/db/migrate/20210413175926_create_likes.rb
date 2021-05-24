# To generate this migration:
# rails g model like user:references question:references

class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    # This table will act as a join table between users and questions
    # to form a many-to-many relationship.
    create_table :likes do |t|
      t.references :user, foreign_key: true
      t.references :question, foreign_key: true

      t.timestamps
    end
  end
end
