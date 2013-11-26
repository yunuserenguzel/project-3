class Like < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user'
  belongs_to :sonic, :class_name => 'Sonic', :foreign_key => 'sonic'
end
