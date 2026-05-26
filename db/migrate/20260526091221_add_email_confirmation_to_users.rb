class AddEmailConfirmationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users,
               :confirmation_token_digest,
               :string

    add_column :users,
               :confirmation_sent_at,
               :datetime

    add_column :users,
               :confirmed_at,
               :datetime

    add_index :users,
              :confirmation_token_digest,
              unique: true
  end
end