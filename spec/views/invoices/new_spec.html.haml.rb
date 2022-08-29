# frozen_string_literal: true

require "rails_helper"

RSpec.describe "invoices/new", type: :view do
  before(:each) do
    assign(:invoice, create("invoice"))
  end

  it "render a invoice" do
    render

    expect(rendered).to have_selector("h1", text: "Invoices")
    expect(rendered).to have_selector("input[type='submit']")
  end
end