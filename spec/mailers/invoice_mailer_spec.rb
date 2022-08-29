# frozen_string_literal: true

require 'rails_helper'

describe InvoiceMailer do
  describe 'confirmation' do
    before do
      @email = 'test@test.com'
    end

    context 'headers confirmation' do
      it 'renders the subject' do
        mail = described_class.confirmation(@email)

        expect(mail.subject).to eq I18n.t('invoice_mailer.confirmation.subject')
      end

      it 'sends to the right email' do
        mail = described_class.confirmation(@email)

        expect(mail.to).to eq [@email]
      end

      it 'renders the from email' do
        mail = described_class.confirmation(@email)

        expect(mail.from).to eq ['soywaltermendez@gmail.com']
      end
    end

    context 'headers error' do
      it 'renders the subject' do
        mail = described_class.error(@email)

        expect(mail.subject).to eq I18n.t('invoice_mailer.error.subject')
      end

      it 'sends to the right email' do
        mail = described_class.error(@email)

        expect(mail.to).to eq [@email]
      end

      it 'renders the from email' do
        mail = described_class.error(@email)

        expect(mail.from).to eq ['soywaltermendez@gmail.com']
      end
    end
  end
end
