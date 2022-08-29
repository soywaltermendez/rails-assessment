# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SetCurrentUser
  before_action :authenticate_user!
  before_action :set_paginate

  def handle_filter
    @filter = String.new
    min_amount_filter = "amount_cents >= #{params[:min_amount]}"
    max_amount_filter = "amount_cents <= #{params[:max_amount]}"

    if params[:min_amount].present? && params[:max_amount].present?
      @filter += min_amount_filter
      @filter += " AND "
      @filter += max_amount_filter
      @filter += " AND "
    elsif params[:min_amount].present?
      @filter += min_amount_filter
      @filter += " AND "
    elsif params[:max_amount].present?
      @filter += max_amount_filter
      @filter += " AND "
    end

    @filter += "user_id = #{current_user.id}"
  end

  private

  def set_paginate
    @per_page = params[:per_page].to_i < 1 ? 10 : params[:per_page] || 10
  end
end
