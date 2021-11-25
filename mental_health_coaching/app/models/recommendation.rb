class Recommendation < ApplicationRecord
  belongs_to :user
  belongs_to :coach
  belongs_to :technique
end
