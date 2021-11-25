class Technique < ApplicationRecord
  has_and_belongs_to_many :problems

  has_many :ratings
  has_many :users, through: :ratings

  has_many :recommendations
  has_many :users, through: :recommendations

  has_many :recommendations
  has_many :coaches, through: :recommendations

  enum gender: [ :male, :female ]
end
