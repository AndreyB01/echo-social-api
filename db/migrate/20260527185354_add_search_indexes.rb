class AddSearchIndexes < ActiveRecord::Migration[7.1]
  def change
    add_index :users,
              :username,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "index_users_on_username_trgm"

    add_index :hashtags,
              :name,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "index_hashtags_on_name_trgm"

    add_index :posts,
              :body,
              using: :gin,
              opclass: :gin_trgm_ops,
              name: "index_posts_on_body_trgm"
  end
end