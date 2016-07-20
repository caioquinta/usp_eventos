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

    it 'must have a location' do
      expect(event.location).to eql 'Localização'
    end

    it 'must not be created without a location' do
      expect(build(:event, location: '')).to_not be_valid
    end

    it 'must have a name' do
      expect(event.name).to eql 'Nome do Evento'
    end

    it 'must not be created without a name' do
      expect(build(:event, name: '')).to_not be_valid
    end

    it 'must have a description' do
      expect(event.description).to eql 'Descrição do Evento'
    end

    it 'must not be created without a description' do
      expect(build(:event, description: '')).to_not be_valid
    end

    it 'should list next_events' do
      expect(Event.next_events.count).to eql 0

      create :next_event
      expect(Event.next_events.count).to eql 1
    end

    it 'should list current_events' do
      expect(Event.current_events.count).to eql 0

      create :current_event
      expect(Event.current_events.count).to eql 1
    end

    it 'should list next and current_events' do
      expect(Event.next_and_current.count).to eql 0

      create :next_event
      create :current_event
      expect(Event.next_and_current.count).to eql 2
    end
  end
end
