class Notification < ActiveRecord::Base
  belongs_to :actor_user, :class_name => 'User', :foreign_key => 'actor_user'
  belongs_to :sonic, :class_name => 'Sonic', :foreign_key => 'sonic'
  belongs_to :affected_user, :class_name => 'User', :foreign_key => 'affected_user'

end
