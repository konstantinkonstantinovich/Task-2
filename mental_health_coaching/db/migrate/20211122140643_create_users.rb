class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :age
      t.string :email
      t.integer :gender
      t.text :about
      t.text :avatar
      t.string :password
      t.references :coach, null: true, foreign_key: true

      t.timestamps
    end
  end
end
