class User < ActiveRecord::Base

  before_create :generate_user_id

  def generate_user_id
    self.id = loop do
      id = rand(100000000..1000000000)
      break id unless User.exists?(id: id)
    end
  end

end

