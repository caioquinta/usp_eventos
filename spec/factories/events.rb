FactoryGirl.define do  
  factory :event do
    association :planner, factory: :user
  end
end