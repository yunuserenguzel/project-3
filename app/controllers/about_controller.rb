class AboutController < ApplicationController
  layout "about"

  before_filter :get_link

  def get_link
    @link = params[:action]
  end

  def company

  end

  def terms

  end

  def privacy

  end

  def contact

  end

  def team
    
  end
end
