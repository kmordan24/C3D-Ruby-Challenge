# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { Faker::Lorem.sentence(word_count: 3) }
    starts_at { Faker::Time.forward(days: 5, period: :morning) }
    ends_at { starts_at + 2.hours }

    association :place
  end
end
