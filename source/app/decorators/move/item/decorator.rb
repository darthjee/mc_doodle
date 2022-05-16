# frozen_string_literal: true

class Move < ApplicationRecord
  class Item < ApplicationRecord
    class Decorator < ::ModelDecorator
      expose :name
      expose :move_id
    end
  end
end
