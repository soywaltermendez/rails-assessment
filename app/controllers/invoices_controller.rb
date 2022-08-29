# frozen_string_literal: true

require './app/jobs/invoice_import_job/'
require 'rqrcode'

class InvoicesController < ApplicationController
  before_action :set_invoice, only: %i[show edit update destroy qr]
  before_action :handle_filter, only: :index

  def index
    @filter_path = root_path
    @invoices = Invoice.where(@filter).order(created_at: :desc)
                       .paginate(page: params[:page], per_page: @per_page)
  end

  def show; end

  def new
    @invoice = Invoice.new
  end

  def import; end

  def upload
    upload = InvoiceUpload.create(invoices: params[:xmls])
    InvoiceImportJob.perform_later(upload, current_user)
    redirect_to root_path, flash: { success: I18n.t('model.invoice.create') }
  rescue Exception => e
    logger.error e
    flash[:error] = 'We had an error, please try again.'
    render :import
  end

  def create
    invoice_json = {
      user: current_user,
      emitter: Person.find_or_create_by(name: invoice_params[:emitter_name], rfc: invoice_params[:emitter_rfc]),
      receiver: Person.find_or_create_by(name: invoice_params[:receiver_name], rfc: invoice_params[:receiver_rfc]),
      invoice_uuid: invoice_params[:invoice_uuid],
      cfdi_digital_stamp: invoice_params[:cfdi_digital_stamp],
      amount_cents: invoice_params[:amount_cents],
      amount_currency: invoice_params[:amount_currency],
      emitted_at: invoice_params[:emitted_at],
      expires_at: invoice_params[:expires_at]
    }

    @invoice = Invoice.create(invoice_json)
    flash[:info] = 'Invoice created.'
    render :edit
  end

  def edit; end

  def update
    invoice_json = {
      emitter: Person.find_or_create_by(name: invoice_params[:emitter_name], rfc: invoice_params[:emitter_rfc]),
      receiver: Person.find_or_create_by(name: invoice_params[:receiver_name], rfc: invoice_params[:receiver_rfc]),
      invoice_uuid: invoice_params[:invoice_uuid],
      cfdi_digital_stamp: invoice_params[:cfdi_digital_stamp],
      amount_cents: invoice_params[:amount_cents],
      amount_currency: invoice_params[:amount_currency],
      emitted_at: invoice_params[:emitted_at],
      expires_at: invoice_params[:expires_at]
    }

    if @invoice.update(invoice_json)
      flash[:success] = I18n.t('model.invoice.update')
      render :show
    else
      render :edit
    end
  end

  def destroy
    @invoice.destroy
    redirect_to root_path, flash: { success: I18n.t('model.invoice.destroy') }
  end

  def qr
    if @invoice.cfdi_digital_stamp.present?
      qrcode = RQRCode::QRCode.new(@invoice.cfdi_digital_stamp)
      @qr_image = qrcode.as_png(
        bit_depth: 1,
        border_modules: 4,
        color_mode: ChunkyPNG::COLOR_GRAYSCALE,
        color: "black",
        file: nil,
        fill: "white",
        module_px_size: 6,
        resize_exactly_to: false,
        resize_gte_to: false,
        size: 120
      )
    end
  end

  private

  def invoice_params
    params.require(:invoice).permit(:invoice_uuid,
                                    :cfdi_digital_stamp,
                                    :amount_cents,
                                    :amount_currency,
                                    :emitter_name,
                                    :emitter_rfc,
                                    :receiver_name,
                                    :receiver_rfc,
                                    :emitted_at,
                                    :expires_at)
  end

  def set_invoice
    @invoice = Invoice.find_by(id: params[:id], user: current_user)
    redirect_to root_path, error: I18n.t('model.invoice.not_exist') if @invoice.nil?
  end
end
