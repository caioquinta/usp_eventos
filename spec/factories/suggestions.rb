FactoryGirl.define do
  sequence :sugestion_email do |n|
    "user#{n}@usp.br"
  end

  factory :suggestion do
    user_name 'user'
    email :suggestion_email
    description 'Sugestão'
  end
end
