class McRouterEventsController < ApplicationController
  def index
    @events = McRouterEvent.order("occurred_at DESC").limit(50).includes(:configuration_active_world)
  end
end
