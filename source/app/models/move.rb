# frozen_string_literal: true

class Move < ApplicationRecord
  ALLOWED_ATTRIBUTES = %i[name].freeze

  belongs_to :user
  has_many :items

  validates :title,
            presence: true,
            length: { maximum: 255 }
end
