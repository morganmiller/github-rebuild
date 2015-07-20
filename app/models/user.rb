class User < ActiveRecord::Base
  def self.from_omniauth(auth_info)
    if user = find_by(uid: auth_info.extra.raw_info.user_id)
      user
    else
      create({name: auth_info.extra.raw_info.name,
              screen_name: auth_info.info.nickname,
              uid: auth_info.uid,
              oauth_token: auth_info.credentials.token,
              image_url: auth_info.info.image})
    end
  end
end
