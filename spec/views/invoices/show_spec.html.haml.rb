# frozen_string_literal: true

require "rails_helper"

RSpec.describe "invoices/show", type: :view do
  before(:each) do
    assign(:invoice, create("invoice"))
  end

  it "render a invoice" do
    render

    expect(rendered).to have_selector("strong", text: "UUID:")
    expect(rendered).to have_selector("strong", text: "Amount:")
    expect(rendered).to have_selector("strong", text: "Emitted Date:")
    expect(rendered).to have_selector("strong", text: "Expires Date:")

    expect(rendered).to have_selector(".banner-title", text: "Invoices")
    expect(rendered).to have_selector("h3", text: "Emitter")
    expect(rendered).to have_selector("h3", text: "Receiver")
  end
end