class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.text :body
      t.boolean :status
      t.references :user, null: true, foreign_key: true
      t.references :coach, null: true, foreign_key: true

      t.timestamps
    end
  end
end
