class CreateArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :articles do |t|
      t.references :user
      t.string :title
      t.text :content
      t.text :introduction
      t.string :status

      t.timestamps
    end
  end
end
