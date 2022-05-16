# frozen_string_literal: true

FactoryBot.define do
  factory :move_category, class: 'Move::Category' do
    sequence(:name) { |n| "Cat ##{n}" }
  end
end
