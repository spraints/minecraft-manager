class MinecraftWorldsController < ApplicationController
  def index
    @worlds = MinecraftWorld.all
    @archived = MinecraftWorld.archived.all
  end

  def show
    @world = MinecraftWorld.unscoped.find(params[:id])
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

  def edit
    @world = MinecraftWorld.find(params[:id])
  end

  def update
    @world = MinecraftWorld.find(params[:id])
    if @world.update(world_params)
      redirect_to @world
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @world = MinecraftWorld.find(params[:id])
    @world.destroy!
    redirect_to action: :index
  end

  def archive
    @world = MinecraftWorld.find(params[:id])
    @world.archive!
    redirect_to action: :index
  end

  private

  def world_params
    params.expect(minecraft_world: [ :display_name, :backend_addr ])
  end
end
