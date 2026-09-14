require "test_helper"

class MessageTest < ActiveSupport::TestCase
  
  
  test "message is valid with required attributes" do
    assert messages(:one).valid?
  end

  
  
  test "message requires content" do
    message = messages(:one)
    message.content = ""

    assert_not message.valid?
    assert_includes message.errors[:content],
                    "can't be blank"
  end

  
  
  test "sender and receiver must be different" do
    message = messages(:one)
    message.receiver = message.sender

    assert_not message.valid?
    assert_includes message.errors[:receiver_id],
                    "must be different from sender"
  end

  
  
  test "message requires a sender" do
    message = messages(:one)
    message.sender = nil

    assert_not message.valid?
  end

  
  
  test "message requires a receiver" do
    message = messages(:one)
    message.receiver = nil

    assert_not message.valid?
  end

  
  
  test "message requires a property" do
    message = messages(:one)
    message.property = nil

    assert_not message.valid?
  end
end
