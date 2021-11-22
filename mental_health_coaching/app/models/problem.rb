class Problem < ApplicationRecord
  has_many :user_problems
  has_many :users, through: :user_problems
  has_many :coach_problems
  has_many :coach, through: :coach_problems
end
