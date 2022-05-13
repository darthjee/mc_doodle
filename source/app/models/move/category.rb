# frozen_string_literal: true

class Move < ApplicationRecord
  class Category < ApplicationRecord
    validates :name,
              presence: true,
              length: { maximum: 10 }
  end
end
