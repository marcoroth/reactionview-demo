class StatusController < ApplicationController
  def show
    @healthy = Ops.healthy?
    @stats = Ops.stats
    @regions = Ops.regions
  end
end
