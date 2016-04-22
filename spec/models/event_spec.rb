require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create :event }
  context 'on creation' do
    it 'event has a user planner' do
      expect(event.planner).to_not be_nil
      expect(event.participants).to be_empty
    end

    it 'event has participants' do
      3.times do
        user = create :user
        event.participants.create user_id: user.id
      end
      expect(event.participants.count).to eql 3
    end

    it 'event dont have participants' do
      expect(event.participants.count).to eql 0
    end

    it 'deve ter um location' do
      expect(event.location).to eql 'Localização'
    end

    it 'não deve criar sem location' do
      expect(build(:event, location: '')).to_not be_valid
    end

    it 'deve ter um name' do
      expect(event.name).to eql 'Nome do Evento'
    end

    it 'não deve criar sem um name' do
      expect(build(:event, name: '')).to_not be_valid
    end

    it 'deve ter um description' do
      expect(event.description).to eql 'Descrição do Evento'
    end

    it 'não deve criar sem uma description' do
      expect(build(:event, description: '')).to_not be_valid
    end

    it 'deve listar proximos eventos' do
      expect(Event.next_events.count).to eql 0

      create :next_event
      expect(Event.next_events.count).to eql 1
    end
  end
end
