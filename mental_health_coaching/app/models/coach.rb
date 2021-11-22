class Coach < ApplicationRecord
  has_many :users, :social_networks

  enum gender: [ :male, :female ]
end
