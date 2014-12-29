class SonicController < ApplicationController

  def list
    @sonics = Sonic.where(:is_resonic => false).order(:created_at => :desc)

  end

  def index
    if Rails.env.development?
      @sonic = Object.new
      @sonic.class.module_eval { attr_accessor :sonic_data, :user, :sonic_thumbnail, :tags}
      @sonic.sonic_data = 's2312946224034h88e1b076baf1d2a44f9dbb62af36ab1ba5ec2703.snc'
      user = @sonic.user = Object.new
      user.class.module_eval {attr_accessor :profile_image_file_name, :profile_image, :fullname, :username, :location}
      user.profile_image_file_name = 1
      user.profile_image = 'u678243093894h2a34f611b93ec49a672deb22654fbceffbd8c4d9.jpg'
      user.fullname = 'Yunus Eren Guzel'
      user.username = 'yeguzel'
      user.location = 'Ankara, TR'
    else
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

end
