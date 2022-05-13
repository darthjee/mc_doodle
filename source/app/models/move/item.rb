class Move < ApplicationRecord
  class Item < ApplicationRecord
    belongs_to :move
    belongs_to :category

    validates :name,
      presence: true,
      length: { maximum: 255 }
  end
end
