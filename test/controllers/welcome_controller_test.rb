require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test "route to index" do
    assert_routing '/', { controller: 'welcome', action: 'index' }
  end
end
