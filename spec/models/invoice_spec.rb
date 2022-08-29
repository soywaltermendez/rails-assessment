# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  it 'is valid with valid attributes' do
    expect(described_class.new(emitter: Person.new, receiver: Person.new, user: User.new)).to be_valid
  end
end
