class AddModerationAndSearchFieldsToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :hidden_at, :datetime

    add_column :posts, :search_vector, :tsvector

    add_index :posts, :search_vector, using: :gin
  end
end