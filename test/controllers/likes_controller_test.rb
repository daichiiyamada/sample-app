require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  test "should not create without login" do
    assert_no_difference 'Like.count' do
      post likes_path
    end
  end

  test "should not destroy without login" do
    assert_no_difference 'Like.count' do
      delete like_path(likes(:one))
    end
  end

end
