require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def create_user
    User.create!(name: "Morgan Miller",
                 screen_name: "morganmiller",
                 uid: 8868319,
                 oauth_token: "d10e0e71a54c645010451d94c3f300ef998a7254",
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
end 
