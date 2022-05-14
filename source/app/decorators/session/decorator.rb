# frozen_string_literal: true

class Session < ApplicationRecord
  class Decorator < ModelDecorator
    expose :id
    expose :name
    expose :email
    expose :login
    expose :token

    delegate :id, :name, :email, :login, to: :user
  end
end
