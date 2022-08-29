# frozen_string_literal: true

require './app/jobs/invoice_import_job/'

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]
  before_action :handle_filter, only: :index

  def index
    @filter_path = root_path
    @invoices = Invoice.where(@filter).order(created_at: :desc)
                       .paginate(page: params[:page], per_page: @per_page)
  end

  def show
  end

  def new
    @invoice = Invoice.new
  end

  def import
  end

  def upload
    upload = InvoiceUpload.create(invoices: params[:xmls])
    InvoiceImportJob.perform_later(upload, current_user)
    redirect_to root_path, flash: { success: I18n.t("model.invoice.create") }
  end

  def create
    invoice = params[:invoice]
    emitter = Person.find_or_create_by(name: invoice[:emitter])
    receiver = Person.find_or_create_by(name: invoice[:receiver])
    invoice_json = {
      user: current_user,
      emitter: emitter,
      receiver: receiver,
      invoice_uuid: invoice[:invoice_uuid],
      cfdi_digital_stamp: invoice[:cfdi_digital_stamp],
      amount_cents: invoice[:amount_cents],
      amount_currency: invoice[:amount_currency],
      emitted_at: invoice[:emitted_at],
      expired_at: invoice[:expired_at]
    }

    @invoice = Invoice.create(invoice_json)
    flash[:info] = "Invoice created."
    render :edit
  end

  def edit
  end

  def update
    invoice = params[:invoice]
    emitter = Person.find_or_create_by(name: invoice[:emitter])
    receiver = Person.find_or_create_by(name: invoice[:receiver])

    invoice_json = {
      emitter: emitter,
      receiver: receiver,
      invoice_uuid: invoice[:invoice_uuid],
      cfdi_digital_stamp: invoice[:cfdi_digital_stamp],
      amount_cents: invoice[:amount_cents],
      amount_currency: invoice[:amount_currency],
      emitted_at: invoice[:emitted_at],
      expires_at: invoice[:expires_at]
    }

    if @invoice.update(invoice_json)
      redirect_to @invoice, flash: { success: I18n.t("model.invoice.update") }
    else
      render :edit
    end
  end

  def destroy
    @invoice.destroy
    redirect_to root_path, flash: { success: I18n.t("model.invoice.destroy") }
  end

  private

  def invoice_params
    params.require(:invoice).permit(:invoice_uuid,
                                    :cfdi_digital_stamp,
                                    :amount_cents,
                                    :amount_currency,
                                    :emitter,
                                    :receiver,
                                    :emitted_at,
                                    :expires_at
    )
  end

  def set_invoice
    @invoice = Invoice.find_by(id: params[:id], user: current_user)
    redirect_to root_path, error: I18n.t("model.invoice.not_exist") if @invoice.nil?
  end
end
