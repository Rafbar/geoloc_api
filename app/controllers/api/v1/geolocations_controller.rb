class Api::V1::GeolocationsController < ApplicationController
  before_action :authorize_user
  before_action :load_geolocation, except: [:create, :index]
  before_action :load_geolocations, only: [:index]

  def index
  end

  def show
  end

  def create
    @geoloc = GeoLocation.new(geoloc_create_params)
    if @geoloc.save
      render :show
    else
      render_unprocessable
    end
  end

  def update
    if @geoloc.update_attributes(geoloc_params)
      render :show
    else
      render_unprocessable
    end
  end

  def destroy
    if @geoloc.destroy
      render json: {}, status: 200
    else
      render_unprocessable
    end
  end

  private

  def load_geolocations
    @geolocs = GeoLocation.limit(100).all
  end

  def load_geolocation
    @geoloc = GeoLocation.find_by_id_or_key(params[:id])
    render json: {}, status: 404 unless @geoloc
  end

  def geoloc_create_params
    params.permit(:key)
  end

  def geoloc_params
    params.permit(:key, :ip, :country_code, :city, :zip, :latitude, :longitude, :workflow_state)
  end

  def render_unprocessable
    render json: {user: @geoloc.errors}, status: :unprocessable_entity
  end

end
