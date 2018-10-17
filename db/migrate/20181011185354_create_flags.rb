class CreateFlags < ActiveRecord::Migration[5.2]
  def change
    create_table :flags do |t|
      t.string :name
      t.integer :style_flag
      t.boolean :active, default: true
      t.datetime :last_update
      t.boolean :is_deleted, default: false
      t.integer :percentage
      t.string :auth_token
      t.belongs_to :organization, foreign_key: true
      t.timestamps
    end
  end
end
