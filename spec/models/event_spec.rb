require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { create :event }
  context 'on creation' do
    it 'event has a user planner' do
      expect(event.planner).to_not be_nil
    end

    it 'event has a user planner' do
      expect(event.participants).to be_empty
    end
  end
end
