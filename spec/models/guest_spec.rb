# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe 'validations' do
    it 'requires a name' do
      guest = described_class.new(email: Faker::Internet.email)
      expect(guest).not_to be_valid
      expect(guest.errors[:name]).to include("can't be blank")
    end

    it 'requires an email' do
      guest = described_class.new(name: Faker::Name.name)
      expect(guest).not_to be_valid
      expect(guest.errors[:email]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:event) }
  end
end