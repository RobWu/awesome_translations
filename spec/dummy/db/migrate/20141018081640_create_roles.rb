class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.belongs_to :user
      t.string :role
    end

    add_index :roles, :user_id
  end
end
