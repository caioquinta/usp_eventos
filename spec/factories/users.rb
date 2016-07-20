FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@usp.br"
  end

  factory :user do
    name 'user'
    email
    password '12345678'
    password_confirmation '12345678'
    preferences ['Exatas']
    factory :user_participant do
      events { [build(:event)] }
    end
  end
end
