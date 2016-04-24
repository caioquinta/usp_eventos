require 'rails_helper'

RSpec.describe Suggestion, type: :model do
  let(:suggestion) { create :suggestion }
  context 'on creation' do
    it 'must have a user_name' do
      expect(suggestion.user_name).to eql 'user'
    end

    it 'dont create without a user_name' do
      expect(build(:suggestion, user_name: '')).to_not be_valid
    end

    it 'must have a description' do
      expect(suggestion.description).to eql 'Sugestão'
    end

    it 'dont create without a description' do
      expect(build(:suggestion, description: '')).to_not be_valid
    end

    it 'dont create without an email' do
      expect(build(:suggestion, email: '')).to_not be_valid
    end
  end
end
