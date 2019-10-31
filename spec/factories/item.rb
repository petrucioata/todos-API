FactoryBot.define do
  factory :item do
    name { Faker::GameOfThrones.quote }
    done { false }
    todo_id { nil }
  end
end
