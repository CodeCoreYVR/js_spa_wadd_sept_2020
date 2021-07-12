class AddOmniauthFieldsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :oauth_token, :string
    add_column :users, :oauth_raw_data, :string
  end
end
