# frozen_string_literal: true

class Guest < ApplicationRecord
  belongs_to :event

  validates :name, presence: true
  validates :email, presence: true
end
