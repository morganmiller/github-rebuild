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
  
  def user_events
    client.user_events(screen_name)
  end
  
  def chart
    # RestClient.get("https://github.com/users/morganmiller/contributions")
    chart = GithubChart.new(screen_name)
    #8B1C62	 	#D73A9D	 	#E992C9	 	#FBEAF4
    chart.colors = ["#000000", "#d6e685", "#8cc665", "#44a340", "#1e6823"]
    chart.svg
  end
  
  def stats
    `githubstats #{screen_name}`
  end
end
