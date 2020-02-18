require 'test_helper'

class PromoteControllerTest < ActionDispatch::IntegrationTest
  test "should get boost" do
    get promote_boost_url
    assert_response :success
  end

  test "should get priority" do
    get promote_priority_url
    assert_response :success
  end

end
