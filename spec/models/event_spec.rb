# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it 'requires a name' do
      event = described_class.new(starts_at: Time.current, ends_at: Time.current + 1.hour)
      expect(event).not_to be_valid
      expect(event.errors[:name]).to include("can't be blank")
    end

    it 'requires a start time' do
      event = described_class.new(name: 'Test Event', ends_at: Time.current + 1.hour)
      expect(event).not_to be_valid
      expect(event.errors[:starts_at]).to include("can't be blank")
    end

    it 'requires an end time' do
      event = described_class.new(name: 'Test Event', starts_at: Time.current)
      expect(event).not_to be_valid
      expect(event.errors[:ends_at]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:place) }
    it { is_expected.to have_many(:guests).dependent(:destroy) }
  end
end
