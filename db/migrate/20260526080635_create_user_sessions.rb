class CreateUserSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true

      t.string :refresh_token_digest, null: false

      t.string :user_agent
      t.string :ip_address

      t.datetime :expires_at, null: false
      t.datetime :revoked_at

      t.timestamps
    end

    add_index :user_sessions, :refresh_token_digest, unique: true
    add_index :user_sessions, :expires_at
  end
end