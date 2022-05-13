# frozen_string_literal: true

# Base decorator
class ModelDecorator < Azeroth::Decorator
  expose :id
  expose :errors, if: :invalid?

  def invalid?
    object.errors.any?
  end

  def errors
    object.errors.messages
  end
end
