FactoryGirl.define do
  factory :event do
    association :planner, factory: :user
    description 'Descrição do Evento'
    name 'Nome do Evento'
  end
end
