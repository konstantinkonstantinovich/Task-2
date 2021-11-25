class CreateTechniques < ActiveRecord::Migration[6.1]
  def change
    create_table :techniques do |t|
      t.string :title
      t.text :description
      t.string :age
      t.integer :gender
      t.integer :steps
      t.string :duration

      t.timestamps
    end
  end
end
