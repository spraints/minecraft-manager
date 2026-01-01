class ConfigurationsController < ApplicationController
  def index
    @current = Configuration.current
    @proposed = Configuration.proposed.all
  end

  def show
    @configuration = Configuration.find(params[:id])
  end

  def new
    @configuration, @config_worlds = ConfigurationBuilder.prepare(Configuration.current)
  end

  def create
    @configuration = ConfigurationBuilder.build_from_params(params)
    if @configuration.save
      redirect_to action: :index
    else
      @config_worlds = ConfigurationBuilder.prepare_worlds(@configuration)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @configuration, @config_worlds = Configuration.find(params[:id])
  end

  def update
    @configuration, @config_worlds, ok = ConfigurationBuilder.update_from_params(params)
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
