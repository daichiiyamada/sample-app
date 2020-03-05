require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @reply_to_user = users(:archer)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end

  test "存在するユーザーに対して返信しようとした場合" do
    user_name = @reply_to_user.user_name
    @micropost.content = "@#{user_name} 投稿できる"
    @micropost.save
    assert @micropost.reload.valid?
  end

  test "返信投稿に対して返信しようとした場合" do
    micropost = @user.microposts.build(content: "Lorem ipsum", replying: true, in_reply_to: @micropost.id)
    micropost.save
    replying_micropost = @user.microposts.build(content: "Lorem ipsum", replying: true, in_reply_to: micropost.id)
    assert_not replying_micropost.valid?
  end
end
