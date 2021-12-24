class CreateSteps < ActiveRecord::Migration[6.1]
  def change
    create_table :steps do |t|
      t.text :body
      t.string :title
      t.integer :number
      t.references :technique, null: false, foreign_key: true

      t.timestamps
    end
  end
end
