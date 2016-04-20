FactoryGirl.define do
  factory :event do
    association :planner, factory: :user
    description 'Descrição do Evento'
    name 'Nome do Evento'
    location 'Localização'
    price 10.0
    factory :next_event do
      begin_date 1.day.from_now
      end_date 10.day.from_now
    end
  end
end
