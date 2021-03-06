class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name
      t.string :last_name
      t.string :bio
      t.string :password_digest
      t.string :role

      t.timestamps
    end
  end
end
