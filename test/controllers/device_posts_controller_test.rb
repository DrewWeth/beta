require 'test_helper'

class DevicePostsControllerTest < ActionController::TestCase
  setup do
    @device_post = device_posts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:device_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create device_post" do
    assert_difference('DevicePost.count') do
      post :create, device_post: { action_id: @device_post.action_id, device_id: @device_post.device_id, post_id: @device_post.post_id }
    end

    assert_redirected_to device_post_path(assigns(:device_post))
  end

  test "should show device_post" do
    get :show, id: @device_post
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @device_post
    assert_response :success
  end

  test "should update device_post" do
    patch :update, id: @device_post, device_post: { action_id: @device_post.action_id, device_id: @device_post.device_id, post_id: @device_post.post_id }
    assert_redirected_to device_post_path(assigns(:device_post))
  end

  test "should destroy device_post" do
    assert_difference('DevicePost.count', -1) do
      delete :destroy, id: @device_post
    end

    assert_redirected_to device_posts_path
  end
end
