# frozen_string_literal: true

# config/initializers/delayed_job.rb
Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.sleep_delay = 10
Delayed::Worker.max_attempts = 1
Delayed::Worker.max_run_time = 5.hours
Delayed::Worker.read_ahead = 10
Delayed::Worker.default_queue_name = 'default'
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.logger = Logger.new(Rails.root.join('log/delayed_job.log'))
Delayed::Worker.queue_attributes = {
  default: { priority: 20 },
  validation: { priority: 10 }
}
