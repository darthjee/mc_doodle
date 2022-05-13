class Move < ApplicationRecord
  class Decorator < ::ModelDecorator
    expose :title
  end
end
