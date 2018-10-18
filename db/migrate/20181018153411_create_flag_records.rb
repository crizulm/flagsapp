class CreateFlagRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :flag_records do |t|
      t.belongs_to :flag, index: true
      t.date :date_start
      t.date :date_end
      t.boolean :active
      t.timestamps
    end
  end
end
