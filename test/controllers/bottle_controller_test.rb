require 'test_helper'

class BottleControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get bottle_index_url
    assert_response :success
  end

end
