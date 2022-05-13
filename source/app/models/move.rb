# frozen_string_literal: true

class Move < ApplicationRecord
  def self.table_name_prefix
    'move_'
  end

  belongs_to :user

  validates :name,
            presence: true,
            length: { maximum: 255 }
end
