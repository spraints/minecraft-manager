class McRouterEventsController < ApplicationController
  def index
    @events = McRouterEvent.order("occurred_at DESC").limit(50)
  end
end
