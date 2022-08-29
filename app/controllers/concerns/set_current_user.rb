# frozen_string_literal: true

module SetCurrentUser
  extend ActiveSupport::Concern

  included do
    before_action :set_current_user, unless: :devise_controller?
  end

  private

  def set_current_user
    Current.user = current_user if current_user.present?
  end
end
