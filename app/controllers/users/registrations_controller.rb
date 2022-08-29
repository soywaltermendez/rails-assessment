# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, only: :create
end