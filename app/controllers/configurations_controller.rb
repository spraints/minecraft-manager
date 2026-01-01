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
    @configuration = Configuration.find(params[:id])
    if !@configuration.edit_ok?
      raise "illegal edit"
    end
    @config_worlds = ConfigurationBuilder.prepare_worlds(@configuration)
  end

  def update
    @configuration = Configuration.find(params[:id])
    if !@configuration.edit_ok?
      raise "illegal edit"
    end
    if ConfigurationBuilder.update_from_params(@configuration, params)
      redirect_to action: :show
    else
      @config_worlds = ConfigurationBuilder.prepare_worlds(@configuration)
      render :edit, status: :unprocessable_entity
    end
  end

  def queue
    ConfigurationActivator.queue!(params[:id])
    redirect_to action: :index
  end
end
