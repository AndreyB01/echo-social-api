class AddStatusToFollows < ActiveRecord::Migration[7.1]
  def change
    add_column :follows, :status, :integer, null: false
  end
end