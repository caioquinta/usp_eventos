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
  end
end
