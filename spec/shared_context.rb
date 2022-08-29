# frozen_string_literal: true

RSpec.shared_context 'shared context' do
  let!(:person) { Person.find_or_create_by!(name: "Person name", rfc: "dasd88sdas8d98") }
end
