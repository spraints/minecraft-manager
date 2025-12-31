class ConfigurationsController < ApplicationController
  def index
    @current = Configuration.current
    @proposed = Configuration.proposed.all
  end

  def show
    @configuration = Configuration.find(params[:id])
  end

  def new
    @configuration = Configuration.new
  end

  def create
    @configuration, ok = ConfigurationBuilder.create_from_params(params)
    if ok
      redirect_to action: :index
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @configuration = Configuration.find(params[:id])
  end

  def update
    @configuration, ok = ConfigurationBuilder.update_from_params(params)
    if ok
      redirect_to action: :update
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def queue
    ConfigurationActivator.queue!(params[:id])
    redirect_to action: :index
  end
end
