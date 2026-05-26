class CreateMutes < ActiveRecord::Migration[7.1]
  def change
    create_table :mutes do |t|
      t.references :muter,
                   null: false,
                   foreign_key: { to_table: :users }

      t.references :muted,
                   null: false,
                   foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :mutes,
              [:muter_id, :muted_id],
              unique: true
  end
end