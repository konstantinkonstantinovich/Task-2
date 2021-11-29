class Coach < ApplicationRecord
  has_many :users
  has_many :social_networks
  has_many :notifications
  has_and_belongs_to_many :problems

  has_many :invitations
  has_many :users, through: :invitations

  has_many :recommendations
  has_many :users, through: :recommendations

  has_many :recommendations
  has_many :techniques, through: :recommendations

  has_one_attached :avatar

  has_secure_password

  validates :age, presence: false
  validates :abouts, presence: false
  validates :gender, presence: false
  validates :experience, presence: false
  validates :education, presence: false
  validates :licenses, presence: false

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/, message: 'Invalid email' }
  enum gender: [ :male, :female ]
end
