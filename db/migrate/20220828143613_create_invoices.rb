# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[5.2]
  def change

    create_table :invoices do |t|
      t.references :user, index: true, null: false, foreign_key: true
      t.string :invoice_uuid
      t.references :emitter, index: true, null: false, foreign_key: {to_table: :people}
      t.references :receiver, index: true, null: false, foreign_key: {to_table: :people}
      t.decimal :amount_cents
      t.string :amount_currency
      t.date :emitted_at
      t.date :expires_at

      t.timestamps
    end
  end
end
