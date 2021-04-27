FactoryBot.define do
  factory :note do
    sequence(:title) { |n| "sample-title-#{n}" }
    body { "sample-body" }
    sequence(:slug) { |n| "sample-note-#{n}" }
    
    association :user
  end
end
