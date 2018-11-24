class CreateEvaluateHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :evaluate_histories do |t|
      t.integer :user_id
      t.boolean :active
      t.datetime :date
      t.belongs_to :flag, foreign_key: true
      t.timestamps
    end
  end
end
