class User < ApplicationRecord
  belongs_to :coach
  has_many :notifications
  has_and_belongs_to_many :problems

  enum gender: [ :male, :female ]
end
