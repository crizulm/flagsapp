class CreateFlagRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :flag_requests do |t|
      t.integer :new_request
      t.integer :new_true_answer
      t.belongs_to :flag, index: true
      t.timestamps
    end
  end
end
