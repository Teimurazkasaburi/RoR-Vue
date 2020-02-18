require 'test_helper'

class AdminsControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get admins_home_url
    assert_response :success
  end

end
