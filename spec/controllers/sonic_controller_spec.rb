require 'spec_helper'

describe SonicController do
  context "create_sonic" do
    before :each do
      sonic_data = fixture_file_upload('files/SNCKL001527e33e440a7c.snc', 'media/snc')
      u = User.new
      token = Authentication.authenticate_user u
      @params = {:format => 'json', :token => token, :sonic_data => sonic_data}
    end

    it "creates a sonic data at server" do
      post :create_sonic, @params
      response.should be_successful
    end
  end
end
