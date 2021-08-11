class CreateDonations < ActiveRecord::Migration[6.1]
  def change
    create_table :donations do |t|
      t.integer :amount

      t.text :status

      t.text :security_key

      t.references :giver, null: false, foreign_key: {to_table: 'users'}

      t.references :receiver, null: false, foreign_key: {to_table: 'users'}

      t.references :answer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
