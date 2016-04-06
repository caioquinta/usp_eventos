FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@usp.br"
  end

  factory :user do
    name 'user'
    email
    password '12345678'
    password_confirmation '12345678'
    factory :user_planner do
      events { [build(:event, user: nil)] }
    end	
  end
end
