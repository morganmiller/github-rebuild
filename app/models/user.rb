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
  
  def git_user
    Octokit.user screen_name
  end
  
  def total_followers
    git_user.followers
  end
  
  def total_following
    git_user.following
  end
  
  def total_starred
    Octokit.starred(screen_name).count  
  end
  
  def followers
    JSON.parse(Octokit.followers(screen_name))
  end

  def following
    JSON.parse(Octokit.following(screen_name))
  end

  def starred
    JSON.parse(Octokit.starred(screen_name))
  end
  
end
