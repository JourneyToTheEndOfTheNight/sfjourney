require 'test_helper'

class DonationsControllerTest < ActionController::TestCase
  test "should get donate" do
    get :donate
    assert_response :success
  end

  test "should get donated" do
    get :donated
    assert_response :success
  end

  test "should get cancelled" do
    get :cancelled
    assert_response :success
  end

end
