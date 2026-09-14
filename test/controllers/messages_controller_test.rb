require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @landlord = users(:one)
    @renter = users(:two)
    @property = properties(:one)

    sign_in @renter
  end

  
  test "should get messages index" do
    get messages_path

    assert_response :success
    assert_select "h1", "Chats"
  end

  
  test "should show conversation" do
    get message_conversation_path(
      property_id: @property.id,
      user_id: @landlord.id
    )

    assert_response :success
    assert_select "h5", /Test Landlord/
  end

  
  test "should create message" do
    assert_difference("Message.count", 1) do
      post messages_path,
           params: {
             message: {
               property_id: @property.id,
               receiver_id: @landlord.id,
               content: "Can I schedule a tour?"
             }
           }
    end

    created_message = Message.order(:created_at).last

    assert_equal @renter.id,
                 created_message.sender_id

    assert_equal @landlord.id,
                 created_message.receiver_id

    assert_equal @property.id,
                 created_message.property_id

    assert_redirected_to message_conversation_path(
      property_id: @property.id,
      user_id: @landlord.id
    )
  end

  
  test "should not create blank message" do
    assert_no_difference("Message.count") do
      post messages_path,
           params: {
             message: {
               property_id: @property.id,
               receiver_id: @landlord.id,
               content: ""
             }
           }
    end

    assert_response :unprocessable_entity
  end

  
  test "should reject unauthorized conversation" do
    get message_conversation_path(
      property_id: @property.id,
      user_id: @renter.id
    )

    assert_redirected_to messages_path
  end

  
  test "should require login" do
    sign_out @renter

    get messages_path

    assert_redirected_to new_user_session_path
  end

  
  test "allows conversation with property owner" do
    property = properties(:one)
    owner = property.landlord

    sign_in users(:two)

    get message_conversation_path(
      property_id: property.id,
      user_id: owner.id
    )

    assert_response :success
  end

  
  test "does not allow user to message themselves" do
    user = users(:two)
    property = properties(:one)

    sign_in user

    get message_conversation_path(
     property_id: property.id,
      user_id: user.id
    )

    assert_redirected_to messages_path
  end

  
  test "does not allow unrelated users into conversation" do
    property = properties(:one)
    unrelated_user = users(:two)
    another_unrelated_user = users(:three)

    sign_in unrelated_user

    get message_conversation_path(
      property_id: property.id,
      user_id: another_unrelated_user.id
    )
    assert_redirected_to messages_path
  end
end
