class SonicController < ApplicationController

  before_filter :require_authentication

  prepare_params_for :create_sonic,
                     :sonic_data => [:required]
  def create_sonic
    @sonic = Sonic.new
    @sonic.sonic_data = params[:sonic_data]
    @sonic.user_id = @authenticated_user.id
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

  prepare_params_for :get_sonics,
                     :after => [:not_empty, :type=>Sonic],
                     :before => [:not_empty, :type=>Sonic]
  def get_sonics
    if params.has_key? :after
      @sonics = Sonic.get_sonic_feed_for_user_after_sonic @authenticated_user,params[:after]
    elsif params.has_key? :before
      @sonics = Sonic.get_sonic_feed_for_user_before_sonic @authenticated_user, params[:before]
    else
      @sonics = Sonic.get_sonic_feed_for_user @authenticated_user
    end
  end

  prepare_params_for :delete_sonic,
                     :sonic => [:required, :type => Sonic]
  def delete_sonic
    sonic = Sonic.find(params[:sonic])
    if sonic.user_id != @authenticated_user.id
      return show_error ErrorCodePermissionDenied, "sonic is not owned by the authenticated user"
    else
      sonic.destroy
    end
  end

  prepare_params_for :likes,
                     :sonic => [:required, :type=>Sonic]
  def likes
    @users = Sonic.likes_of_sonic params[:sonic]
  end

  prepare_params_for :write_comment,
                     :sonic => [:required, :type=>Sonic],
                     :text => [:required, :not_empty, :type => String]
  def write_comment
    @comment = Comment.create(:sonic_id => params[:sonic],
                   :text => params[:text],
                   :user_id => @authenticated_user.id
    )
  end

  prepare_params_for :comments,
                     :sonic => [:required, :type=>Sonic]
  def comments
    @comments = Comment.get_comments_for_sonic_id params[:sonic]
  end

  prepare_params_for :resonic,
                     :sonic => [:required,:type=>Sonic]
  def resonic
    Sonic.resonic_for_sonic_and_user params[:sonic],@authenticated_user
    @sonic = Sonic.find(params[:sonic])
  end



end
