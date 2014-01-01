require 'spec_helper'

describe Comment do

  context "get_comments" do
    before :each do
      @sonic = Sonic.create
      5.times do
        user = User.create
        Comment.create(:user_id => user.id, :sonic_id => @sonic.id, :text => 'comment text')
      end
    end
    it "brings all comments" do
      expect(Comment.get_comments_for_sonic_id(@sonic.id).count).to eq (5)
    end
    it "returns empty array if sonic_id is not found" do
      expect(Comment.get_comments_for_sonic_id(-1).count).to eq(0)
    end
  end
end
