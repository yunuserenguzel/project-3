namespace :initializer do

  task :start => :environment do
    yeguzel = User.where(:username => 'yeguzel').first
    if yeguzel == nil
      return
    end
    ['stanley','house','scarlett','kunis','dexter'].each do |username|
      user = User.where(:username => username).first
      next if user == nil
      Follow.destroy_all(:follower_user_id => user.id)
      Follow.destroy_all(:followed_user_id => user.id)
      Sonic.destroy_all(:user_id => user.id)
      Like.destroy_all(:user_id =>user.id)
      Comment.destroy_all(:user_id=>user.id)
      user.destroy
    end
    stanley = User.create(
      :username => 'stanley',
      :fullname => 'Stanley Kubrick',
      :email => 'stanley@abc.com',
      :website => 'www.stanleykubrick.de',
      :profile_image => 'http://ia.media-imdb.com/images/M/MV5BMTIwMzAwMzg1MV5BMl5BanBnXkFtZTYwMjc4ODQ2._V1_SX640_SY720_.jpg',
      :location => 'Berlin',
      :bio => "American film director, screenwriter, producer, cinematographer"
    )

    house = User.create(
      :username => 'house',
      :fullname => 'Hugh Laurie',
      :email => 'hugh@house.com',
      :profile_image => 'http://www.todevahouse.com/wp-content/uploads/2013/12/hugh-laurie-house-season-6robocop-villain-will-behugh-laurie----the-hollywood-news---the-fufpymtc.jpg',
      :website => 'hughlaurieblues.com',
      :location => 'New york',
      :bio => 'James Hugh Calum Laurie, OBE, known as Hugh Laurie, is an English actor, comedian, writer, musician, and director.'
    )

    scarlett = User.create(
      :username => 'scarlett',
      :fullname => 'Scarlett Johansson',
      :email => 'scarlett@johansson.com',
      :profile_image => 'http://www.myfilmviews.com/wp-content/uploads/2012/12/scarlett_johansson.jpg',
      :website => 'www.scarlettjohansson.org',
      :location => 'Paris',
      :bio => 'Scarlett Johansson is an American actress, model and singer'
    )

    kunis = User.create(
      :username => 'kunis',
      :fullname => 'Mila Kunis',
      :email => 'mila@kunis.com',
      :profile_image => 'http://static1.wikia.nocookie.net/__cb20130222211527/twilightsaga/images/2/2f/Mila-Kunis-1.jpg',
      :website => 'en.wikipedia.org/wiki/Mila_Kunis',
      :location => 'Russia Moscov',
      :bio => 'American actress and voice artist..'
    )

    dexter = User.create(
      :username => 'dexter',
      :fullname => 'Micheal C. Hall',
      :email => 'mic@hall.com',
      :profile_image => 'http://img2-3.timeinc.net/ew/i/2013/06/06/Michael-C-Hall.jpg',
      :website => 'en.wikipedia.org/wiki/Michael_C._Hall',
      :location => 'Miami USA',
      :bio => 'American actor'
    )

    [stanley,house,scarlett,kunis,dexter].each do |user|
      user.passhash = User.hash_password('1234')
      user.save
      user.follow_user yeguzel
      yeguzel.follow_user user
    end




  end


end













