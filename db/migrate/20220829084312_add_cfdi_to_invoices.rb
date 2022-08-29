# frozen_string_literal: true

class AddCfdiToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :cfdi_digital_stamp, :string
  end
end
