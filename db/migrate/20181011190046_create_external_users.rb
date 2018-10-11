class CreateExternalUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :external_users do |t|
      t.integer :user_id
      t.boolean :active
      t.belongs_to :flag, foreign_key: true

      t.timestamps
    end
  end
end
