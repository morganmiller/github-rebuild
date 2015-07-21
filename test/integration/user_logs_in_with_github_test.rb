require 'test_helper'
class UserLogsInWithGithubTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  def setup
    Capybara.app = GithubRebuild::Application
    stub_omniauth
  end
  
  test 'logging in' do
    skip
    visit '/'
    assert_equal 200, page.status_code
    click_on 'Sign in with Github'
    assert_equal '/', current_path
    assert page.has_content?("worace")
    assert page.has_link?("logout")
  end
  
  test 'logging out' do
    skip
    visit '/'
    click_on 'Sign in with Github'
    click_link 'logout'
    assert_equal '/', current_path
    refute page.has_content?("worace")
    refute page.has_content?("logout")
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
            name: "Horace",
          }
        },
        credentials: {
          token: "pizza",
        },
        info: {
          image: "https://avatars.githubusercontent.com/u/8868319?v=3",
          nickname: "worace"
        }
      })
  end
end
