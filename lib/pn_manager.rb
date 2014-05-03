class PNManager

  def self.send_notification push_token,platform,notification
    if !(Rails.env.production? || Rails.env.staging?)
      return
    end
    if platform == 'ios'
      APNS.host = 'gateway.sandbox.push.apple.com'
      APNS.pem  = 'config/sonicraph_ios_03_05_2014.pem'
      APNS.pass = 'Sonic2014'
      APNS.send_notification(push_token, notification)
    elsif platform == 'android'
      GCM.host = 'https://android.googleapis.com/gcm/send'
      GCM.format = :json
      GCM.key = "AIzaSyDppFGZUuyITM7g0SBB_C9tx0GNMJpswO0"
      destination = [push_token]
      GCM.send_notification( destination, notification)
    end
  end

  def self.truncate_message message
    length = 140
    if message.length <= length
      return message
    else
      return message[0..(length-4)] + "..."
    end
  end

  def self.send_new_notification_notification auth, message
    if auth == nil
      return false
    elsif auth.platform == 'ios'
      puts "Sending iOS notification" if !Rails.env.test?
      PNManager.send_notification auth.push_token,auth.platform,{
        :other => {
          'aps' => {
            'alert' => self.truncate_message(message),
            #'badge' => badge,
            'sound' => 'default'
            #'content-available' => 1
          }
        }
      }
      puts "iOS Notification sent" if !Rails.env.test?
      return true
    elsif auth.platform == 'android'
      puts "Sending Android notification" if !Rails.env.test?
      PNManager.send_notification auth.push_token,auth.platform,{
        :sender=>send_to.message.sender.to_json(:for_user => send_to.message.sender),
        :message=>self.truncate_message(send_to.message.text),
        :badge=>Message.get_new_messages_for_user(send_to.receiver).count
      }
      puts "Android Notification sent" if !Rails.env.test?
      return true
    end
  end

end