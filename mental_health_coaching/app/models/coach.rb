class Coach < ApplicationRecord
  has_many :users, :social_networks, :notifications
  has_and_belongs_to_many :problems

  has_secure_password
  
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
  enum gender: [ :male, :female ]
end
