class User < ApplicationRecord
  belongs_to :coach
  enum gender: [ :male, :female ]
end
