class Room < ApplicationRecord
  belongs_to :coach
  belongs_to :user
  has_many :messages, dependent: :delete_all
end
