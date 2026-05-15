class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    enable_extension "citext" unless extension_enabled?("citext")

    create_table :users do |t|
      t.citext :email, null: false
      t.citext :username, null: false
      t.string :password_digest, null: false
      t.string :display_name, null: false
      t.text :bio
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true

    add_check_constraint :users,
                         "char_length(username) >= 3",
                         name: "users_username_length_check"
    add_check_constraint :users,
                         "char_length(username) <= 30",
                         name: "users_username_max_length_check"
  end
end