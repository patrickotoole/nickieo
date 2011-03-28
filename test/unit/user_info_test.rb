require 'test_helper'

class UserInfoTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert UserInfo.new.valid?
  end
end
