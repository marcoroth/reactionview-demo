class ActivityController < ApplicationController
  def show
    @kinds = Ops.feed_kinds
    @feed = Ops.feed(herb_state("filter", ""))
  end
end
