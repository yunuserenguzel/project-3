class SonicController < ApplicationController

  before_filter :require_authentication

  prepare_params_for :create_sonic,
                     :sonic_data => [:required]
  def create_sonic
    @sonic = Sonic.new
    @sonic.sonic_data = params[:sonic_data]
    @sonic.user = @authenticated_user
    #TODO: add latitude and longitude
    @sonic.save
  end

  prepare_params_for :like_sonic,
                     :sonic => [:required, :type => Sonic]
  def like_sonic
    @sonic = Sonic.find(params[:sonic])
    @sonic.like_sonic_for_user @authenticated_user
  end

  prepare_params_for :dislike_sonic,
                     :sonic => [:required, :type => Sonic]
  def dislike_sonic
    @sonic = Sonic.find(params[:sonic])
    @sonic.dislike_sonic_for_user @authenticated_user
  end

  prepare_params_for :get_sonics_after,
                     :sonic=>[:not_empty,:type=>Sonic]
  def get_sonics_after
    sonic = params[:sonic]
    @sonics = Sonic.get_sonic_feed_for_user_after_sonic @authenticated_user, sonic
  end


end
