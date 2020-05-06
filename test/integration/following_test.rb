require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
	include Warden::Test::Helpers

  def setup
  	@luffy = users(:luffy)
  	login_as(@luffy, :scope => :user)
  end

  test "should see following/followers count" do

  	get users_path
  	assert_match @luffy.following.count.to_s, response.body
  	assert_match @luffy.followers.count.to_s, response.body
  	assert_select "a[href=?]", following_user_path(@luffy)
  	assert_select "a[href=?]", followers_user_path(@luffy)
  	assert_match "1 following", response.body
  	assert_match "1 follower", response.body

  end

  test "following page" do

  	get following_user_path(@luffy)
  	assert_select "h2", "User Following"
  	assert_match @luffy.following.first.name, response.body
  	assert_match "1 following", response.body

  end

  test "followers page" do

  	get followers_user_path(@luffy)
  	assert_select "h2", "User Followers"
  	assert_match @luffy.followers.first.name, response.body
  	assert_match "1 follower", response.body

  end

  test "follow button" do

  	get user_path(@luffy)
  	assert_select "input.btn-success", count: 0
  	assert_select "input.btn-primary", count: 1

  	get user_path(users(:zoro))
  	assert_select "input.btn-primary", count: 2

  	get user_path(users(:sanji))
  	assert_select "input.btn-success", count: 1
  	assert_select "input.btn-primary", count: 1
  end

end