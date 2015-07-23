require "test_helper"

class WelcomeControllerTest < ActionController::TestCase
  
  test "fetches user data with VCR" do
    u = User.create!(name: "Morgan",
                     screen_name: "morganmiller",
                     uid: "8868319",
                     oauth_token: ENV["sample_user_token"])
    session[:user_id] = u.id
    VCR.use_cassette("welcome") do
      get :index
      assert_response :success
      assert_select "#user-feed"
    end
  end
end
