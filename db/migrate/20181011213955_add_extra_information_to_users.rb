class AddExtraInformationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string,  null: false, default: ""
    add_column :users, :surname, :string,  null: false, default: ""
    add_column :users, :is_admin, :boolean,  null: false, default: false
    add_reference :users, :organization
  end
end
