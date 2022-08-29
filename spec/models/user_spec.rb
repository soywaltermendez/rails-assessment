# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    expect(described_class.new(email: 'test@test.com', password: 'test123')).to be_valid
  end
end
