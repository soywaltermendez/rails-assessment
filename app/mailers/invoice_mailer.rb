# frozen_string_literal: true

class InvoiceMailer < ApplicationMailer
  def confirmation(email)
    mail(to: email, subject: I18n.t("invoice_mailer.confirmation.subject"))
  end

  def error(email, exception)
    @exception = exception
    mail(to: email, subject: I18n.t("invoice_mailer.error.subject"))
  end
end
