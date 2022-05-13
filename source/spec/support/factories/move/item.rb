# frozen_string_literal: true

FactoryBot.define do
  factory :move_item, class: 'Move::Item' do
    sequence(:name) { |n| "Item ##{n}" }
    move
  end
end
