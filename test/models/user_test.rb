require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@email.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  # 测试用户实例有效
  test "should be valid" do
    assert @user.valid?
  end

  # 测试用户名不能为空
  test "name should be present" do
    @user.name = "  "
    assert_not @user.valid?
  end

  # 测试邮箱不能为空
  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  # 测试用户名不能太长
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # 测试邮箱不能太长
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # 测试邮箱地址有效性
  test "email validation should accept vailid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-er@foo.bar.com
                          firsr.last@foo.cn alice+bob@baz.us]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end

    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # 测试邮箱地址是唯一的!!!
  test "email adresses should be unique" do
    duplicate_user = @user.dup
    # duplicate_user.email = @user.email.downcase
    @user.save
    assert_not duplicate_user.save?
  end

  # 测试邮箱地址应该被存储为小写格式
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExampLe.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # 测试密码不能为空
  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  #　测试密码最短长度为６
  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "ａ" * 5
    assert_not @user.valid?
  end
end