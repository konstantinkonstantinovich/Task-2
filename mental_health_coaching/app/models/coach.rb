class Coach < ApplicationRecord
  has_many :users, :social_networks, :notifications
  has_many :coach_problems
  has_many :problem, through: :coach_problems

  enum gender: [ :male, :female ]
end
