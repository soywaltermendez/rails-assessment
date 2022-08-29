# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: :create
end
