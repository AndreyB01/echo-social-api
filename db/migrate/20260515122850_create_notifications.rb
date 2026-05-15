class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications do |t|
      t.references :user,
                   null: false,
                   foreign_key: true

      t.references :actor,
                   null: false,
                   foreign_key: { to_table: :users }

      t.string :notification_type,
               null: false

      t.references :notifiable,
                   polymorphic: true,
                   null: false

      t.datetime :read_at

      t.timestamps
    end

    add_index :notifications, :notification_type
    add_index :notifications, :read_at
    add_index :notifications, :created_at
  end
end