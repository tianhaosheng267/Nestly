











ActiveRecord::Schema[8.1].define(version: 2026_07_29_152600) do
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
  add_foreign_key "messages", "properties"
  add_foreign_key "messages", "users", column: "receiver_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "properties", "users", column: "landlord_id"
  add_foreign_key "swipes", "properties"
end
