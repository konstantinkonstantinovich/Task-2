class User < ApplicationRecord
  belongs_to :coach
  has_many :notifications
  has_many :user_problems
  has_many :problems, through: :user_problems

  enum gender: [ :male, :female ]
end
