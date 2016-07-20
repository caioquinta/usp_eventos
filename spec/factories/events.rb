FactoryGirl.define do
  factory :event do
    association :planner, factory: :user
    description 'Descrição do Evento'
    name 'Nome do Evento'
    location 'Localização'
    price 10.0
    tag_list %w(Exatas Humanas Biológicas)
    factory :next_event do
      begin_date 1.day.from_now
      end_date 10.day.from_now
    end
    factory :current_event do
      begin_date 1.day.ago
      end_date 10.day.from_now
    end
  end
end
