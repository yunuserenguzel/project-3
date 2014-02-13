class AddThumbnailToSonic < ActiveRecord::Migration
  def change
    add_attachment :sonics, :sonic_thumbnail
  end
end
