# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_10_24_054517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "banner_ads", force: :cascade do |t|
    t.string "ref_no"
    t.string "status", default: "INACTIVE"
    t.datetime "expiring_date"
    t.string "url"
    t.string "banner_type"
    t.integer "duration", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "amount", default: 0
    t.index ["ref_no"], name: "index_banner_ads_on_ref_no"
    t.index ["user_id"], name: "index_banner_ads_on_user_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "ref_no"
    t.string "status", default: "INACTIVE"
    t.string "url"
    t.datetime "expiring_date"
    t.integer "duration", default: 1
    t.integer "user_id"
    t.string "amount", default: "0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ref_no"], name: "index_brands_on_ref_no"
    t.index ["user_id"], name: "index_brands_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.integer "user_id"
    t.integer "forum_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_id"], name: "index_comments_on_forum_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.text "body"
    t.string "owner"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner"], name: "index_contacts_on_owner"
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "forums", force: :cascade do |t|
    t.string "subject"
    t.string "category"
    t.text "body"
    t.integer "comments_count", default: 0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "permalink"
    t.index ["permalink"], name: "index_forums_on_permalink"
    t.index ["subject"], name: "index_forums_on_subject"
    t.index ["user_id"], name: "index_forums_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.datetime "time"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "markers", force: :cascade do |t|
    t.boolean "saved", default: false, null: false
    t.integer "user_id"
    t.integer "post_id"
    t.string "type_of_maker"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["post_id"], name: "index_markers_on_post_id"
    t.index ["user_id"], name: "index_markers_on_user_id"
  end

  create_table "meta_data", force: :cascade do |t|
    t.bigint "post_id"
    t.string "site"
    t.string "title"
    t.string "description"
    t.string "keywords"
    t.string "charset"
    t.boolean "reverse"
    t.boolean "noindex"
    t.boolean "nofollow"
    t.boolean "noarchive"
    t.string "canonical"
    t.string "image_src"
    t.string "og_title"
    t.string "og_type"
    t.string "og_url"
    t.string "og_image"
    t.string "og_video_director"
    t.string "og_video_writer"
    t.string "twitter_card"
    t.string "twitter_site"
    t.string "twitter_creator"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "edited", default: false
    t.index ["post_id"], name: "index_meta_data_on_post_id"
  end

  create_table "post_requests", force: :cascade do |t|
    t.string "purpose"
    t.integer "budget"
    t.string "type_of_property"
    t.string "state"
    t.string "lga"
    t.string "area"
    t.text "description"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "bedrooms"
    t.index ["user_id"], name: "index_post_requests_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "price"
    t.string "duration"
    t.string "description"
    t.string "title"
    t.string "purpose"
    t.string "use_of_property"
    t.string "type_of_property"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.integer "toliets"
    t.string "video_link"
    t.string "street"
    t.string "lga"
    t.string "state"
    t.string "permalink"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "area"
    t.string "square_meters"
    t.string "reference_id"
    t.string "tags"
    t.integer "boost", default: 0
    t.integer "priority", default: 0
    t.decimal "score", default: "0.0"
    t.datetime "promotion_updated_at"
    t.integer "view_count", default: 0
    t.boolean "unpublish", default: false, null: false
    t.index ["permalink"], name: "index_posts_on_permalink"
    t.index ["reference_id"], name: "index_posts_on_reference_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "plan", default: "FREE"
    t.integer "amount", default: 0
    t.datetime "expiring_date"
    t.datetime "start_date"
    t.integer "boost", default: 0
    t.integer "priorities", default: 0
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_post", default: 3
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "ref_no"
    t.integer "amount", default: 0
    t.string "transaction_for"
    t.integer "user_id"
    t.integer "duration", default: 1
    t.string "status", default: "PENDING"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ref_no"], name: "index_transactions_on_ref_no"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "f_name"
    t.string "l_name"
    t.string "username", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "account_type"
    t.string "phone"
    t.jsonb "address"
    t.text "about"
    t.string "ucid"
    t.boolean "admin", default: false, null: false
    t.string "company"
    t.string "country_code"
    t.integer "posts_count", default: 0
    t.integer "boost_count", default: 0
    t.integer "priority_count", default: 0
    t.integer "post_requests_count", default: 0
    t.string "whatsapp"
    t.string "country_code_whatsapp"
    t.boolean "verified", default: false, null: false
    t.datetime "last_logged_in"
    t.boolean "super_user", default: false, null: false
    t.datetime "logged_in_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["username"], name: "index_users_on_username"
  end

  create_table "verify_users", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_verify_users_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "meta_data", "posts"
end
