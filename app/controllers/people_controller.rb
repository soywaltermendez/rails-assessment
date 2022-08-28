# frozen_string_literal: true

class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :destroy]
  before_action :handle_filter, only: :show

  # GET /people/1
  def show
    @filter_path = person_path(@person)
    @invoices = @person.invoices_emitted.where(@filter)
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: @per_page)
  end

  private

  def set_person
    @person = Person.find(params[:id])
  end
end
