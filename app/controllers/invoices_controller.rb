# frozen_string_literal: true

require './app/jobs/invoice_import_job/'

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :destroy]
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

  def create
    upload = InvoiceUpload.create(invoices: params[:xmls])
    InvoiceImportJob.perform_later(upload, current_user)
    redirect_to root_path, flash: { success: I18n.t("model.invoice.create") }
  rescue Exception => e
    logger.error e
    @invoice = Invoice.new
    flash[:error] = "We had an error, please try again."
    render :new
  end

  def destroy
    @invoice.destroy
    redirect_to root_path, flash: { success: I18n.t("model.invoice.destroy") }
  end

  private

  def set_invoice
    @invoice = Invoice.find_by(id: params[:id], user: current_user)
    redirect_to root_path, error: I18n.t("model.invoice.not_exist") if @invoice.nil?
  end
end
