require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get sitemap" do
    get pages_sitemap_url
    assert_response :success
  end

end
