class AddCategoryToReports < ActiveRecord::Migration[7.1]
  def change
    add_column :reports, :category, :string
    add_index :reports, :category
  end
end