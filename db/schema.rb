# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_09_22_010000) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "apartment_communities", force: :cascade do |t|
    t.string "address"
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.datetime "fetched_at", null: false
    t.float "latitude", null: false
    t.float "longitude", null: false
    t.string "name", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
    t.string "website"
    t.index ["external_id"], name: "index_apartment_communities_on_external_id", unique: true
  end

  create_table "apartment_searches", force: :cascade do |t|
    t.json "community_ids", default: [], null: false
    t.datetime "created_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.integer "radius_miles", null: false
    t.datetime "searched_at"
    t.boolean "truncated", default: false, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.string "zip_code", null: false
    t.index ["user_id"], name: "index_apartment_searches_on_user_id", unique: true
  end

  create_table "community_swipes", force: :cascade do |t|
    t.integer "apartment_community_id", null: false
    t.datetime "created_at", null: false
    t.string "direction", null: false
    t.boolean "pinned", default: false, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["apartment_community_id"], name: "index_community_swipes_on_apartment_community_id"
    t.index ["user_id", "apartment_community_id"], name: "index_community_swipes_on_user_id_and_apartment_community_id", unique: true
    t.index ["user_id"], name: "index_community_swipes_on_user_id"
  end

  create_table "email_conversations", force: :cascade do |t|
    t.integer "apartment_community_id"
    t.datetime "created_at", null: false
    t.integer "gmail_connection_id", null: false
    t.string "gmail_thread_id"
    t.integer "property_id"
    t.string "recipient", null: false
    t.string "subject", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["apartment_community_id"], name: "index_email_conversations_on_apartment_community_id"
    t.index ["gmail_connection_id"], name: "index_email_conversations_on_gmail_connection_id"
    t.index ["property_id"], name: "index_email_conversations_on_property_id"
    t.index ["user_id"], name: "index_email_conversations_on_user_id"
  end

  create_table "email_deliveries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "email_conversation_id", null: false
    t.string "request_token", null: false
    t.string "status", default: "sending", null: false
    t.datetime "updated_at", null: false
    t.index ["email_conversation_id"], name: "index_email_deliveries_on_email_conversation_id"
    t.index ["request_token"], name: "index_email_deliveries_on_request_token", unique: true
  end

  create_table "gmail_connections", force: :cascade do |t|
    t.text "access_token"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "expires_at"
    t.text "refresh_token"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_gmail_connections_on_user_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.integer "property_id", null: false
    t.integer "receiver_id", null: false
    t.integer "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_messages_on_property_id"
    t.index ["receiver_id"], name: "index_messages_on_receiver_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.string "image_path"
    t.integer "property_id"
    t.datetime "updated_at", null: false
  end

  create_table "properties", force: :cascade do |t|
    t.string "address", null: false
    t.text "amenities"
    t.text "city", null: false
    t.datetime "created_at", null: false
    t.date "date_available"
    t.integer "landlord_id", null: false
    t.integer "main_image_id"
    t.integer "monthly_rent"
    t.integer "num_bathrooms", null: false
    t.integer "num_bedrooms", null: false
    t.boolean "pet_friendly", default: false
    t.decimal "sqft"
    t.text "state", null: false
    t.datetime "updated_at", null: false
    t.string "zip"
  end

  create_table "swipes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "direction", null: false
    t.boolean "pinned", default: false, null: false
    t.integer "property_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["property_id"], name: "index_swipes_on_property_id"
    t.index ["user_id", "property_id"], name: "index_swipes_on_user_id_and_property_id", unique: true
  end

  create_table "tour_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "message"
    t.integer "property_id"
    t.date "requested_date"
    t.time "requested_time"
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", default: "", null: false
    t.text "housing_preferences"
    t.string "name", null: false
    t.string "password_digest"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "apartment_searches", "users"
  add_foreign_key "community_swipes", "apartment_communities"
  add_foreign_key "community_swipes", "users"
  add_foreign_key "email_conversations", "apartment_communities"
  add_foreign_key "email_conversations", "gmail_connections"
  add_foreign_key "email_conversations", "properties"
  add_foreign_key "email_conversations", "users"
  add_foreign_key "email_deliveries", "email_conversations"
  add_foreign_key "gmail_connections", "users"
  add_foreign_key "messages", "properties"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "properties", "users", column: "landlord_id"
  add_foreign_key "swipes", "properties"
end
