class CreateIdempotencyKeys < ActiveRecord::Migration[7.1]
  def change
    create_table :idempotency_keys do |t|
      t.string :key, null: false
      t.references :user, null: false, foreign_key: true
      t.string :response_status
      t.jsonb :response_body
      t.timestamps
    end
    add_index :idempotency_keys, :key, unique: true
    add_index :idempotency_keys, :created_at
  end
end