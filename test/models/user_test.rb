require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def create_user
    User.create!(name: "Morgan Miller",
                 screen_name: "morganmiller",
                 uid: 8868319,
                 oauth_token: ENV["sample_user_token"],
                 image_url: "https://avatars.githubusercontent.com/u/8868319?v=3")
  end
  
  test "knows number of followers" do
    user = create_user
    assert_equal 6, user.total_followers
  end
  
  test "knows number following" do
    user = create_user
    assert_equal 0, user.total_following
  end

  test "knows number starred" do
    user = create_user
    assert_equal 4, user.total_starred
  end
  
  test "knows total commits" do
    skip
    user = create_user
    assert user.total_commits >= 246
  end
end 
