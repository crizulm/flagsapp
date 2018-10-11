class CreateFlags < ActiveRecord::Migration[5.2]
  def change
    create_table :flags do |t|
      t.string :name
      t.integer :type
      t.boolean :active
      t.integer :percentage
      t.string :token
      t.belongs_to :organizations, foreign_key: true

      t.timestamps
    end
  end
end
