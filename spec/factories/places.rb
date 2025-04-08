# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    name { Faker::Lorem.sentence(word_count: 3) }
  end
end
