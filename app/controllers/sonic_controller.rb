class SonicController < ApplicationController

  before_filter :require_authentication

  prepare_params_for :create_sonic,
                     :sonic_data => [:required]
  def create_sonic
    @sonic = Sonic.new
    @sonic.sonic_data = params[:sonic_data]
    @sonic.user = @authenticated_user
    #TODO: add latidute and longitude
    @sonic.save
  end

  prepare_params_for :like_sonic,
                     :sonic => [:required, :type => Sonic]
  def like_sonic
    @sonic = Sonic.find(params[:sonic])
    @sonic.like_sonic_for_user @authenticated_user
  end

end
