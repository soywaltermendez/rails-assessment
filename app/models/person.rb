# frozen_string_literal: true

class Person < ApplicationRecord
  has_many :invoices_emitted, foreign_key: 'emitter_id', class_name: 'Invoice',
                              dependent: :destroy, inverse_of: :person
  has_many :invoices_received, foreign_key: 'receiver_id', class_name: 'Invoice',
                               dependent: :destroy, inverse_of: :person

  def emitted_amount
    invoices_emitted.where(user: Current.user).group(:amount_currency).sum(:amount_cents)
  end
end
