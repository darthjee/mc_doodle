# frozen_string_literal: true

class Move < ApplicationRecord
  class Decorator < ::ModelDecorator
    expose :title
  end
end
