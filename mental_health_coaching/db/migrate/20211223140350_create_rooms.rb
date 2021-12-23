class CreateRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :rooms do |t|
      t.references :coach, null: true, foreign_key: true
      t.belongs_to :user
      t.timestamps
    end
  end
end
