# frozen_string_literal: true

class Invoice < ApplicationRecord
  belongs_to :user
  belongs_to :emitter, class_name: 'Person'
  belongs_to :receiver, class_name: 'Person'
end
