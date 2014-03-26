class SonicController < ApplicationController


  def index
    @sonic = Sonic.where(:id=>params[:s]).first
    @isIphone = request.env['HTTP_USER_AGENT'].downcase.match(/iphone/)
    if @sonic
      @iphoneUrl = "sonicraph://sonic/#{@sonic.id}"
    else
      @iphoneUrl = "sonicraph://open"
    end
    render :layout => false
  end

end
