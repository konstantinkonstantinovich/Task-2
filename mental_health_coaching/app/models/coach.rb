class Coach < ApplicationRecord
  has_many :users, :social_networks, :notifications

  enum gender: [ :male, :female ]
end
