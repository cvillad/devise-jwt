FactoryBot.define do
  factory :note do
    title { "sample-title" }
    body { "sample-body" }
    
    association :user
  end
end
