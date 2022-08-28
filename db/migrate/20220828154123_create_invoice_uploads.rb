# frozen_string_literal: true

class CreateInvoiceUploads < ActiveRecord::Migration[5.2]
  def change

    create_table :invoice_uploads do |t|
      t.timestamps
    end
  end
end
