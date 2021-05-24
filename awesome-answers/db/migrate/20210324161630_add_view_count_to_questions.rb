class AddViewCountToQuestions < ActiveRecord::Migration[6.1]
  # To generate a migration run:
  # rails g migration <name-of-migration> <column-name>:<column-type>

  # The command for this file was:
  # rails g migration add_view_count_to_questions view_count:integer
  def change
    # Use the "add_column" method to add columns to a table
    # Its arguments are:
    # 1. The table name to add the column to as a symbol
    # 2. The new column's name as a symbol
    # 3. The data type of the new column as a symbol
    add_column :questions, :view_count, :integer
  end
end
