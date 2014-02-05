class SonicController < ApplicationController

  before_filter :require_authentication
  prepare_params_for :create_sonic,
                     :sonic_data => [:required],
                     :latitude => [:not_empty],
                     :longitude => [:not_empty],
                     :tags => [:required, :type => String]
  def create_sonic
    @sonic = Sonic.new
    @sonic.sonic_data = params[:sonic_data]
    @sonic.user_id = @authenticated_user.id
    tags = params[:tags].strip
    if tags.length > 0
      @sonic.tags = tags
    end
    #TODO: add latitude and longitude
    @sonic.save
  end

  prepare_params_for :like_sonic,
                     :sonic => [:required, :type => Sonic]
  def like_sonic
    Sonic.like_sonic_for_user params[:sonic],@authenticated_user
    @sonic = Sonic.retrieve_sonic_for_user params[:sonic], @authenticated_user
  end

  prepare_params_for :dislike_sonic,
                     :sonic => [:required, :type => Sonic]
  def dislike_sonic
    Sonic.unlike_sonic_for_user params[:sonic],@authenticated_user
    @sonic = Sonic.retrieve_sonic_for_user params[:sonic], @authenticated_user
  end

  prepare_params_for :get_sonics,
                     :after => [:not_empty, :type=>Sonic],
                     :before => [:not_empty, :type=>Sonic],
                     :of_user => [:not_empty, :type=>User],
                     :me_liked => [:not_empty]
  def get_sonics
    @sonics = Sonic.get_sonic_feed_for_user @authenticated_user, params
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
    @users = Like.likes_of_sonic params[:sonic]
  end

  prepare_params_for :write_comment,
                     :sonic => [:required, :type=>Sonic],
                     :text => [:required, :not_empty, :type => String]
  def write_comment
    @comment = Sonic.comment_sonic_for_user params[:text],params[:sonic],@authenticated_user
    @sonic = Sonic.retrieve_sonic_for_user params[:sonic], @authenticated_user
  end

  prepare_params_for :comments,
                     :sonic => [:required, :type=>Sonic]
  def comments
    @comments = Comment.get_comments_for_sonic_id params[:sonic]
  end

  prepare_params_for :delete_comment,
                     :comment => [:required]
  def delete_comment
    Comment.where(:id => params[:comment]).each do |comment|
      if comment.user_id == @authenticated_user.id || comment.sonic.user_id == @authenticated_user.id
        comment.destroy
      end
    end
  end

  prepare_params_for :resonic,
                     :sonic => [:required,:type=>Sonic]
  def resonic
    Sonic.resonic_for_sonic_and_user params[:sonic],@authenticated_user
    @sonic = Sonic.retrieve_sonic_for_user params[:sonic],@authenticated_user.id
  end

  prepare_params_for :resonics,
                     :sonic => [:required, :type => Sonic]
  def resonics
    @users = Sonic.get_users_resoniced_sonic params[:sonic]
  end

  prepare_params_for :delete_resonic,
                     :sonic => [:required]
  def delete_resonic
    Sonic.delete_resonic_for_sonic_and_user params[:sonic],@authenticated_user.id
    @sonic = Sonic.retrieve_sonic_for_user params[:sonic], @authenticated_user.id
  end

  prepare_params_for :search,
                     :query => [:required, :not_empty]
  def search
    @sonics = Sonic.search_query_for_user params[:query], @authenticated_user
  end


end
