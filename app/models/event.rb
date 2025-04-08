# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :place

  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  has_many :guests, dependent: :destroy

  def guest_count
    guests.count
  end

  def has_guests?
    guests.exists?
  end
end
