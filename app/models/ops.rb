module Ops
  FLAKINESS = {
    "Refetch" => 0.05,
    "Geo lookups" => 0.2,
    "Catalog sync" => 0.35
  }.freeze

  def self.services
    FLAKINESS.map do |name, flakiness|
      up = rand > flakiness

      { name: name, up: up, label: up ? "up" : "slow" }
    end
  end

  def self.healthy?
    rand > 0.3
  end

  def self.stats
    [
      { name: "Requests / min", value: rand(2400..3800).to_s, delta: "+#{rand(2..14)}%", good: true },
      { name: "Active connections", value: rand(120..340).to_s, delta: "+#{rand(1..9)}%", good: true },
      { name: "p95 latency", value: "#{rand(80..240)} ms", delta: "#{rand > 0.5 ? "-" : "+"}#{rand(1..12)}%", good: rand > 0.4 },
      { name: "Error rate", value: "0.0#{rand(1..9)}%", delta: "-#{rand(1..5)}%", good: true }
    ]
  end

  def self.regions
    latencies = ["Frankfurt", "Zurich", "Virginia", "Singapore"].map { |name| [name, rand(40..220)] }
    slowest = latencies.map(&:last).max

    latencies.map do |name, latency|
      { name: name, latency: latency, percent: (latency * 100.0 / slowest).round }
    end
  end

  EVENTS = [
    { id: "deploy-142", kind: "deploy", icon: "🚀", text: "Deployed v2.4.1 to production", actor: "marco", at: "2 minutes ago" },
    { id: "merge-517", kind: "merge", icon: "🔀", text: "Merged \"Ship item statics with deferred payloads\"", actor: "marco", at: "9 minutes ago" },
    { id: "alert-88", kind: "alert", icon: "🔥", text: "p95 latency spiked in Frankfurt, recovered on its own", actor: "monitor", at: "14 minutes ago" },
    { id: "signup-2201", kind: "signup", icon: "🎉", text: "reactionview-demo got its 2,000th visitor", actor: "analytics", at: "31 minutes ago" },
    { id: "deploy-141", kind: "deploy", icon: "🚀", text: "Deployed v2.4.0 to production", actor: "marco", at: "1 hour ago" },
    { id: "merge-516", kind: "merge", icon: "🔀", text: "Merged \"Invalidate stale server reads\"", actor: "marco", at: "2 hours ago" },
    { id: "alert-87", kind: "alert", icon: "⚠️", text: "Catalog sync fell behind by 40 seconds", actor: "monitor", at: "3 hours ago" },
    { id: "signup-2137", kind: "signup", icon: "🎉", text: "64 new visitors in one hour, a new record", actor: "analytics", at: "5 hours ago" },
    { id: "deploy-140", kind: "deploy", icon: "🚀", text: "Deployed v2.3.9 to production", actor: "marco", at: "yesterday" },
    { id: "merge-515", kind: "merge", icon: "🔀", text: "Merged \"Keyed slot type\"", actor: "marco", at: "yesterday" }
  ].freeze

  def self.feed(kind)
    pulse = { id: "pulse", kind: "pulse", icon: "💚", text: "Health check passed across all regions", actor: "monitor", at: "just now, at #{Time.current.strftime("%H:%M:%S")}" }
    events = kind.to_s.empty? ? EVENTS : EVENTS.select { |event| event[:kind] == kind }

    kind.to_s.empty? ? [pulse, *events] : events
  end

  def self.feed_kinds
    [["", "All"], ["deploy", "Deploys"], ["merge", "Merges"], ["alert", "Alerts"], ["signup", "Milestones"]]
  end
end
