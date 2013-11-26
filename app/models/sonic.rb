class Sonic < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => 'user'

  before_create :generate_sonic_id

  def generate_sonic_id
    self.id = loop do
      id = rand(100000000..1000000000)
      break id unless User.exists?(id: id)
    end
  end
end
