class MinecraftWorldsController < ApplicationController
  def index
    @worlds = MinecraftWorld.all
  end

  def show
    @world = MinecraftWorld.find(params[:id])
  end

  def new
    @world = MinecraftWorld.new
  end

  def create
    @world = MinecraftWorld.new(world_params)
    if @world.save
      redirect_to @world
    else
      render :new, status: :unprocessable_entity
    end
  end

  # todo - allow edit when the backend hasn't been in any configurations.
  # todo - allow destroy when the backend hasn't been in any configurations.
  # todo - allow archive when the backend isn't in the current configuration.
  #   <%= button_to "Delete", @product, method: :delete, data: { turbo_confirm: "Are you sure?" } %>

  private

  def world_params
    params.expect(minecraft_world: [ :display_name, :backend_addr ])
  end
end
