# frozen_string_literal: true

class Move < ApplicationRecord
  class Category < ApplicationRecord
    class Decorator < ::ModelDecorator
      expose :name
    end
  end
end
