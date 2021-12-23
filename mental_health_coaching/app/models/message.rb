class Message < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :coach, optional: true
  belongs_to :room
end
