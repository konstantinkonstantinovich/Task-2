class Coach < ApplicationRecord
  has_many :users, :social_networks, :notifications
  has_and_belongs_to_many :problems

  enum gender: [ :male, :female ]
end
