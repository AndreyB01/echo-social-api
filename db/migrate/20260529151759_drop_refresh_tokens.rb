class DropRefreshTokens < ActiveRecord::Migration[7.1]
  def change
    drop_table :refresh_tokens do |t|
      t.references :user
      t.string :token_digest
      t.datetime :expires_at
      t.datetime :revoked_at

      t.timestamps
    end
  end
end

