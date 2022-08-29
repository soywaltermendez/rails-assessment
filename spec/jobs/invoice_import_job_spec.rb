# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe InvoiceImportJob, type: :job do
  include ActiveJob::TestHelper

  let(:job) { described_class.perform_later([{}], create('user')) }

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'is in default queue' do
    expect(described_class.new.queue_name).to eq('default')
  end
end
