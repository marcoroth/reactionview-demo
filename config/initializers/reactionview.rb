# frozen_string_literal: true

ReActionView.configure do |config|
  config.intercept_erb = true
  config.debug_mode = false
  config.slots = :client
end
