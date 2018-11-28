class CreateFlagRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :flag_records do |t|
      t.belongs_to :flag, index: true
      t.datetime :date_start
      t.datetime :date_end
      t.boolean :active
      t.timestamps
    end
  end
end
