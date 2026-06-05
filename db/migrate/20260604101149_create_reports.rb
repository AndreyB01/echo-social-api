class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.references :reporter,
                   null: false,
                   foreign_key: { to_table: :users }

      t.string :reportable_type, null: false
      t.bigint :reportable_id, null: false

      t.string :reason, null: false

      t.string :status,
               null: false,
               default: "pending"

      t.timestamps
    end

    add_index :reports,
              %i[reportable_type reportable_id]

    add_index :reports,
              :status
  end
end