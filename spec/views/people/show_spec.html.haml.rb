# frozen_string_literal: true

require "rails_helper"

RSpec.describe "people/show", type: :view do
  before(:each) do
    person = create("person")
    assign(:person, person)
    assign(:filter_path, person_path(person))
  end

  it "render a book without invoices" do
    @invoices = []
    render

    expect(rendered).to have_selector(".banner-title", text: "Person")
    expect(rendered).to have_selector(".legend", text: "No invoice found")
  end

  it "render a book with invoices object" do
    create("invoice")
    @invoices = Invoice.order(created_at: :desc)
                       .paginate(page: params[:page], per_page: @per_page)
    render

    expect(rendered).to have_selector(".banner-title", text: "Person")
    expect(rendered).to have_selector(".banner-title", text: "Invoices")
    expect(rendered).to have_selector(".table-container")
  end
end