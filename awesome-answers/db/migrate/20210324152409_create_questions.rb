class CreateQuestions < ActiveRecord::Migration[6.1]
  # This migration was generated when we generated the question
  # model using the following command. If no type is specified,
  # string is the default data type (title is a string in this case)
  # rails g model title body:text

  # To check the status of migrations: 
  # rails db:migrate:status

  # To migrate all pending migrations:
  # rails db:migrate

  # With the "change" method, Active Record is smart enough to know 
  # how to reverse the change if we rollback. We could alternatively
  # use "up" and "down" methods to specify what to do if we migrate
  # vs. rolling back. 
  # To reverse the last migration:
  # rails db:rollback

  def change
    create_table :questions do |t|
      # Automatically generated an "id" that will autoincrement
      # and acts as our primary key
      t.string :title # This created VARCHAR(255) column "title"
      t.text :body # This created a TEXT column "body"

      # t.timestamps is added by default but you can remove it
      # if not needed. This will create "created_at" and 
      # "updated_at" which will automatically updated when created 
      # and updated.
      t.timestamps
    end
  end
end
