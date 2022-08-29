# frozen_string_literal: true

require "rails_helper"

RSpec.describe "invoices/index", type: :view do
  before(:each) do
    create("invoice")
    @invoices = Invoice.order(created_at: :desc)
                       .paginate(page: params[:page], per_page: @per_page)
  end

  it "render a invoices" do
    render

    expect(rendered).to have_selector("h1", text: "Invoices")
    expect(rendered).to have_selector("button[type='submit']")
  end
end