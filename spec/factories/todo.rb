FactoryBot.define do
  factory :todo do
    # wrapping faker methods in a block ensures unique data(dynamic data every time)
    title { Faker::Lorem.word }
    created_by { Faker::Number.number(10) }
  end
end
