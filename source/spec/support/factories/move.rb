# frozen_string_literal: true

FactoryBot.define do
  factory :move, class: 'Move' do
    sequence(:title) { |n| "Move ##{n}" }
    user
  end
end
