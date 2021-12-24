class Step < ApplicationRecord
  belongs_to :technique, optional: true
end
