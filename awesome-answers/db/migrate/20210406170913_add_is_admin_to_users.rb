# We generated this migration with:
# rails g migration add_is_admin_to_users is_admin:boolean

class AddIsAdminToUsers < ActiveRecord::Migration[6.1]
  def change
    # The default for new users is false for "is_admin"
    add_column :users, :is_admin, :boolean, default: false
  end
end
