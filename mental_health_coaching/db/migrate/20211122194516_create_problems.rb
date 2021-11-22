class CreateProblems < ActiveRecord::Migration[6.1]
  def change
    create_table :problems do |t|
      t.string :name

      t.timestamps
    end

    create_table :user_problems do |t|
      t.belongs_to :user
      t.belongs_to :problem
      t.timestamps
    end

    create_table :coach_problems do |t|
      t.belongs_to :coach
      t.belongs_to :problem
      t.timestamps
    end

  end
end
