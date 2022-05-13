class Move < ApplicationRecord
  class Item < ApplicationRecord
    belongs_to :move

    validates :name,
      presence: true,
      length: { maximum: 255 }
  end
end
