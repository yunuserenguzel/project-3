require 'json'
namespace :initializer do

  task :emails => :environment do


    json_string = '{"emails":[{"email":"dannyflcn@gmail.com","created_at":"2013-12-26 23:09:47","ip":"88.226.100.0"}, {"email":"exculuber@gmail.com","created_at":"2013-12-26 20:00:54","ip":"78.181.93.128"}, {"email":"eedursun@gmail.com","created_at":"2013-12-27 14:57:24","ip":"78.167.83.233"}, {"email":"burhan__eyuboglu@gmail.com","created_at":"2013-12-29 14:32:51","ip":"5.46.78.125"}, {"email":"ilkerkoksali@gmail.com","created_at":"2013-12-29 14:36:12","ip":"188.57.208.77"}, {"email":"a","created_at":"2013-12-30 17:59:11","ip":"78.181.93.128"}, {"email":"as","created_at":"2013-12-30 18:01:31","ip":"78.181.93.128"}, {"email":"asd","created_at":"2013-12-30 18:02:12","ip":"78.181.93.128"}, {"email":"qwe","created_at":"2013-12-30 18:03:38","ip":"78.181.93.128"}, {"email":"muratserif@gmail.com","created_at":"2013-12-31 09:50:21","ip":"81.214.28.102"}, {"email":"f\u00c4\u00b1at","created_at":"2013-12-31 10:19:12","ip":"81.214.28.102"}, {"email":"oykumkilic@hotmail.com","created_at":"2014-01-02 19:22:09","ip":"78.186.150.78"}, {"email":"hello@yolcu-iskender.com","created_at":"2014-01-04 11:32:45","ip":"149.0.34.141"}, {"email":"mthazar@gmail.com","created_at":"2014-01-05 18:43:45","ip":"76.120.27.77"}, {"email":"ceylan.dumlu@gmail.com","created_at":"2014-01-05 18:45:59","ip":"76.120.27.77"}, {"email":"oslemercin@gmail.com","created_at":"2014-01-06 11:04:51","ip":"88.229.126.129"}, {"email":"dincerhazar@yahoo.com","created_at":"2014-01-16 14:56:47","ip":"88.226.102.190"}, {"email":"ihazar@yahoo.com","created_at":"2014-02-01 18:51:22","ip":"88.226.69.120"}, {"email":"serapsarigul@yahoo.com","created_at":"2014-02-02 13:07:01","ip":"5.46.92.163"}, {"email":"tugcedinc_91@hotmail.com","created_at":"2014-02-03 09:26:22","ip":"78.169.204.79"}, {"email":"rmznhanci.gmail.com","created_at":"2014-02-04 13:32:46","ip":"5.46.3.166"}, {"email":"hilal.hi@gmail.com","created_at":"2014-02-07 20:27:12","ip":"5.46.10.169"}, {"email":"denizdemirdag@gmail.com","created_at":"2014-02-08 17:56:02","ip":"178.240.17.44"}, {"email":"canberk.ovayurt@gmail.com","created_at":"2014-02-09 21:24:06","ip":"46.197.222.223"}, {"email":"e.gurses@nexum.com.tr","created_at":"2014-02-13 12:33:39","ip":"188.57.138.184"}, {"email":"enisgayretli@icloud.com","created_at":"2014-02-21 17:03:27","ip":"212.252.106.50"}, {"email":"sametesen86@gmail.com","created_at":"2014-02-23 10:14:37","ip":"88.244.62.9"}, {"email":"nishank@brightjourney.com","created_at":"2014-02-23 20:20:02","ip":"182.64.111.57"}, {"email":"akcoraberkay@gmail.com","created_at":"2014-02-26 14:41:46","ip":"188.57.173.55"}, {"email":"e.surekli@gmail.com","created_at":"2014-02-26 14:43:08","ip":"188.57.161.201"}, {"email":"umutcan.duman@gmail.com","created_at":"2014-02-27 15:53:07","ip":"144.122.27.63"}, {"email":"bfatihdogan@gmail.com","created_at":"2014-03-07 15:21:20","ip":"5.46.82.123"}, {"email":"mertdagtekin@hotmail.com","created_at":"2014-03-09 14:23:34","ip":"78.162.72.158"}, {"email":"eren_guzel@hotmail.com","created_at":"2014-03-10 14:14:36","ip":"95.6.60.3"}]}'

    emails = JSON.parse(json_string)
    emails = emails["emails"]
    emails.each do |e|
      if !Email.exists?(:address => e["email"])
        Email.create(:address => e["email"], :created_at => e["created_at"], :ip => e["ip"])
      end
    end

  end

  task :start => :environment do

    ['stanley','house','scarlett','kunis','dexter','danny','yeguzel','ceren'].each do |username|
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

    ceren = User.create(
      :username => 'ceren',
      :fullname => 'Ceren Turan',
      :email => 'ceren@sonicraph.com',
    )

    dincer = User.create(
      :username => 'danny',
      :fullname => 'Dinçer Hazar',
      :email => 'dincer@sonicraph.com',
      :profile_image => 'https://fbcdn-sphotos-h-a.akamaihd.net/hphotos-ak-frc3/t1/430369_281875421878591_1583705225_n.jpg',
      :website => 'sonicraph.com',
      :location => 'Ankara TR'
    )

    yunus = User.create(
      :username => 'yeguzel',
      :fullname => 'Yunus Eren Güzel',
      :email => 'exculuber@gmail.com',
      :profile_image => 'http://images.ak.instagram.com/profiles/profile_415543736_75sq_1383719434.jpg',
      :website => 'yunuserenguzel.com.tr',
      :location => 'Ankara'
    )

    #dexter = User.create(
    #  :username => 'dexter',
    #  :fullname => 'Micheal C. Hall',
    #  :email => 'mic@hall.com',
    #  :profile_image => 'http://img2-3.timeinc.net/ew/i/2013/06/06/Michael-C-Hall.jpg',
    #  :website => 'en.wikipedia.org/wiki/Michael_C._Hall',
    #  :location => 'Miami USA',
    #  :bio => 'American actor'
    #)

    [stanley,house,scarlett,kunis,ceren,yunus,dincer].each do |user|
      user.passhash = User.hash_password('1234')
      user.save
    end




  end




end













