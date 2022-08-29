# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InvoicesController, type: :controller do
  include ActiveJob::TestHelper
  include_context 'shared context'

  before do
    @user = create(:user)
    sign_in @user
    @file = fixture_file_upload('test.xml', 'text/xml')
    ActiveJob::Base.queue_adapter = :test
  end

  describe 'GET #index' do
    it 'render invoice index view' do
      get :index, params: { use_route: 'invoices' }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('index')
    end
  end

  describe 'GET #show' do
    it 'render invoice show view' do
      invoice = create(:invoice, user: @user)
      get :show, params: { use_route: 'invoices', id: invoice.id }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('show')
    end
  end

  describe '#new' do
    it 'render invoice show view' do
      get :new, params: { use_route: 'invoices' }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('new')
    end

    it 'create invoice' do
      invoice_json = {
        user: @user,
        emitter: 'test',
        receiver: 'test',
        invoice_uuid: 'test',
        amount_cents: 10,
        amount_currency: 'test',
        emitted_at: '2022-08-18',
        expires_at: '2022-08-19'
      }
      post :create, params: { use_route: 'invoices', invoice: invoice_json }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('edit')
    end
  end

  describe '#edit' do
    it 'render invoice edit view' do
      invoice = create(:invoice, user: @user)
      get :edit, params: { use_route: 'invoices', id: invoice.id }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('edit')
    end

    it 'update invoice' do
      invoice = create(:invoice, user: @user)
      patch :update, params: { use_route: 'invoices', id: invoice.id, invoice: { invoice_uuid: 'test' } }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('show')
    end
  end

  describe 'POST #create with import' do
    it 'render invoice show view' do
      get :import, params: { use_route: 'invoices/import' }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('import')
    end

    it 'render new view with errors' do
      post :import, params: { use_route: 'invoices/import' }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('import')
    end

    it 'create invoice upload job' do
      array_of_files = []
      array_of_files << @file

      expect do
        perform_enqueued_jobs do
          post :upload, params: { use_route: 'invoices/import', xmls: array_of_files }
        end
      end.to change(Invoice, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    it 'delete invoice' do
      invoice = create(:invoice, user: @user)
      expect do
        delete :destroy, params: { use_route: 'invoices', id: invoice.id }
      end.to change(Invoice, :count).by(-1)
    end
  end

  describe '#qr' do
    it 'render qr' do
      invoice = create(:invoice, user: @user)
      get :qr, params: { use_route: 'invoices', id: invoice.id }
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('qr')
    end
  end
end
