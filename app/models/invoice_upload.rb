# frozen_string_literal: true

class InvoiceUpload < ApplicationRecord
  has_many_attached :invoices
end
