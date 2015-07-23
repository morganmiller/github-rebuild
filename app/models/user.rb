class User < ActiveRecord::Base

  def self.from_omniauth(auth_info)
    if user = find_by(uid: auth_info.extra.raw_info.user_id)
      user.update_by_auth(auth_info)
      user.save!
      user
    else
      create_by_auth(auth_info)
    end
  end

  def self.new_user_data(auth_info)
    {name: auth_info.extra.raw_info.name,
      screen_name: auth_info.info.nickname,
      uid: auth_info.uid,
      oauth_token: auth_info.credentials.token,
      image_url: auth_info.info.image}
  end

  def self.create_by_auth(auth_info)
    create(new_user_data(auth_info))
  end

  def update_by_auth(auth_info)
    self.update_attributes(new_user_data(auth_info))
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
    client.starred
  end
  
  def organizations
    client.organizations
  end
  
  def total_commits
    client.repos.each_with_object([]) do |repo, count|
      count << client.commits(repo.full_name, author: screen_name).count
    end.sum
  end
  
  def user_events
    client.user_events(screen_name)
  end
  
  def chart
    chart = GithubChart.new(screen_name)
    chart.colors = ["#F5F5DC", "#b1e1c0", "#499a7c", "#215346", "#193023"]
    chart.svg
  end
  
  def repos
    client.repos
  end
end
