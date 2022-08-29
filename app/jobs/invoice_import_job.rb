# frozen_string_literal: true

require 'nokogiri'

class InvoiceImportJob < ApplicationJob
  queue_as :default
  rescue_from Exception do |exception|
    Rails.logger.error exception
  end

  def perform(invoice_upload, current_user)
    @current_user = current_user

    invoice_upload.invoices.each do |invoice|
      ActiveRecord::Base.transaction do
        xml_json = Hash.from_xml(invoice.download).with_indifferent_access

        validate_xml(xml_json)
        handle_xml(xml_json)
      end
    end

    InvoiceMailer.confirmation(current_user.email).deliver
  end

  private

  def validate_xml(xml)
    if xml.key?(:hash)
      xml_json = xml[:hash]
      validate_invoice_info(:invoice_uuid, xml_json)
      validate_invoice_info(:cfdi_digital_stamp, xml_json)
      validate_invoice_info(:amount_cents, xml_json)
      validate_invoice_info(:amount_currency, xml_json)
      validate_invoice_info(:emitted_at, xml_json)
      validate_invoice_info(:expires_at, xml_json)
      validate_person(:emitter, xml_json, xml_json[:emitter])
      validate_person(:receiver, xml_json, xml_json[:receiver])
    else
      raise StandardError, 'Missing hash key'
    end
  end

  def validate_person(key, hash, person_hash)
    if hash.key?(key)
      if person_hash.key?(person_hash[:name]) || person_hash[:name].blank?
        raise StandardError, "Missing #{key} name"
      elsif person_hash.key?(person_hash[:rfc]) || person_hash[:rfc].blank?
        raise StandardError, "Missing #{key} rfc"
      end
    else
      raise StandardError, "Missing #{key}"
    end
  end

  def validate_invoice_info(key, hash)
    raise StandardError, "Missing #{key}" if !hash.key?(key) || hash[key].blank?
  end

  def handle_xml(xml)
    xml_json = xml[:hash]
    xml_json[:user] = @current_user
    xml_json[:emitter] = handle_person(xml_json[:emitter])
    xml_json[:receiver] = handle_person(xml_json[:receiver])
    Invoice.create!(xml_json) if Invoice.find_by(invoice_uuid: xml_json[:invoice_uuid], user: @current_user).nil?
  end

  def handle_person(data)
    Person.find_or_create_by(data)
  end
end
