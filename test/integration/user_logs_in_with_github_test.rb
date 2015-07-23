require 'test_helper'

class UserLogsInWithGithubTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  
  def setup
    Capybara.app = GithubRebuild::Application
    stub_omniauth
  end
  
  test 'logging in' do
    User.any_instance.stubs(:total_followers).returns(30)
    User.any_instance.stubs(:total_following).returns(30)
    User.any_instance.stubs(:total_starred).returns(30)
    User.any_instance.stubs(:total_starred)
        .returns([{avatar_url: "http://img.jpeg", login: "name"}])
    User.any_instance.stubs(:chart).returns("<a></a>")
    User.any_instance.stubs(:stats).returns(30)
    payload = stub(size: 30)
    repo = stub(name: "repo", full_name: "url", open_issues_count: 0)
    event = stub(type: "PushEvent", payload: payload, repo: repo)
    User.any_instance.stubs(:user_events)
        .returns([event])
    organization = stub(avatar_url: "url", login: "login")
    User.any_instance.stubs(:organizations)
        .returns([organization])
    User.any_instance.stubs(:repos)
      .returns([repo])
    visit '/'
    assert_equal 200, page.status_code
    click_on 'Sign in with Github'
    assert_equal '/', current_path
    assert page.has_content?("morganmiller")
  end
  
  test 'logging in with vcr' do
    VCR.use_cassette("login with vcr") do
      visit '/'
      click_on 'Sign in with Github'
      assert page.has_content?("morganmiller")
    end
  end

  def stub_omniauth
    # first, set OmniAuth to run in test mode
    OmniAuth.config.test_mode = true
    # then, provide a set of fake oauth data that
    # omniauth will use when a user tries to authenticate:
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
        provider: 'github',
        extra: {
          raw_info: {
            user_id: "1234",
            name: "Morgan",
          }
        },
        credentials: {
          token: ENV["sample_user_token"],
        },
        info: {
          image: "https://avatars.githubusercontent.com/u/8868319?v=3",
          nickname: "morganmiller"
        }
      })
  end
end
