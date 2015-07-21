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
  
  def client
    Octokit::Client.new(:access_token => oauth_token)
  end
  
  def git_user
    client.user
  end
  
  def total_followers
    git_user.followers
  end
  
  def total_following
    git_user.following
  end
  
  def total_starred
    client.starred.count  
  end
  
  def followers
    JSON.parse(client.followers(screen_name))
  end

  def following
    JSON.parse(client.following(screen_name))
  end

  def starred
    JSON.parse(client.starred(screen_name))
  end
  
  def total_commits
    client.repos.each_with_object([]) do |repo, count|
      count << client.commits(repo.full_name, author: screen_name).count
    end.sum
  end
  
end
