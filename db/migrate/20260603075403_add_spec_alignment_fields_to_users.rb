class AddSpecAlignmentFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :banned_at, :datetime
    add_column :users, :posts_count, :integer, null: false, default: 0
  end
end