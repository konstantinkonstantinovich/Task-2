class User < ApplicationRecord
  belongs_to :coach
  has_many :notifications

  enum gender: [ :male, :female ]
end
