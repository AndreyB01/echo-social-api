class CreatePostMentions < ActiveRecord::Migration[7.1]
  def change
    create_table :post_mentions do |t|
      t.references :post,
                   null: false,
                   foreign_key: true

      t.references :user,
                   null: false,
                   foreign_key: true

      t.timestamps
    end

    add_index :post_mentions,
              [:post_id, :user_id],
              unique: true
  end
end