# frozen_string_literal: true

require "herb/engine/scoped_style/visitor"
require "herb/engine/visitors/source_attribution_visitor"

ReActionView.configure do |config|
  config.intercept_erb = true
  config.debug_mode = true
  config.slots = :client

  config.transform_visitors = [
    Herb::Engine::ScopedStyle::Visitor.new,
    Herb::Engine::SourceAttributionVisitor.new,
    # Herb::Engine::Validators::SecurityValidator.new(fatal: true)
  ]
end
