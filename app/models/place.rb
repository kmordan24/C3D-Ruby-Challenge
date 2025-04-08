# frozen_string_literal: true

class Place < ApplicationRecord
  has_many :events, dependent: :destroy

  validates :name, presence: true

  def has_events?
    events.exists?
  end
end
