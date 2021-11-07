class CreateSearchAnalytics < ActiveRecord::Migration[6.1]
  def change
    create_table :search_analytics do |t|
      t.string :text
      t.integer :count, default: 0, null: false
      t.references :user

      t.timestamps
    end
  end
end
