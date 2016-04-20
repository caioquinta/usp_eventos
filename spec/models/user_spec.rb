require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  context 'on creation' do
    it 'deve ter um name' do
      expect(user.name).to eql 'user'
    end

    it 'não deve criar sem name' do
      expect(build(:event, name: '')).to_not be_valid
    end
  end
end
