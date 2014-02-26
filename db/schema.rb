# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140224234418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "activities", force: true do |t|
    t.string   "activity_type",                    null: false
    t.string   "name",              default: "",   null: false
    t.string   "link"
    t.string   "venue"
    t.text     "address"
    t.text     "contact"
    t.float    "price"
    t.date     "date",                             null: false
    t.time     "start_time"
    t.time     "end_time"
    t.text     "notes"
    t.date     "deadline"
    t.integer  "tickets_available"
    t.boolean  "deposit_required"
    t.boolean  "cc_required"
    t.integer  "min_age"
    t.string   "gender"
    t.boolean  "is_active",         default: true
    t.boolean  "is_approved"
    t.integer  "approved_by"
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["trip_id"], name: "index_activities_on_trip_id", using: :btree
  add_index "activities", ["user_id"], name: "index_activities_on_user_id", using: :btree

  create_table "assets", force: true do |t|
    t.string   "asset"
    t.string   "content_type"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "token_secret"
    t.integer  "expires"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["user_id"], name: "index_authentications_on_user_id", using: :btree

  create_table "groups", force: true do |t|
    t.string   "name",         default: "",   null: false
    t.text     "description"
    t.text     "group_type"
    t.text     "location"
    t.text     "avatar"
    t.text     "facebook_url"
    t.text     "meetup_url"
    t.text     "groupme_id"
    t.boolean  "is_active",    default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", force: true do |t|
    t.string   "email",      default: "", null: false
    t.string   "full_name"
    t.string   "avatar"
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "invitations", ["trip_id"], name: "index_invitations_on_trip_id", using: :btree
  add_index "invitations", ["user_id"], name: "index_invitations_on_user_id", using: :btree

  create_table "lodgings", force: true do |t|
    t.string   "lodging_type"
    t.string   "name",          default: "",   null: false
    t.string   "link"
    t.text     "contact"
    t.date     "checkin_date",                 null: false
    t.time     "checkin_time"
    t.date     "checkout_date",                null: false
    t.text     "address"
    t.float    "star_rating"
    t.string   "reviews_link"
    t.text     "notes"
    t.string   "cover_photo"
    t.boolean  "is_active",     default: true
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lodgings", ["trip_id"], name: "index_lodgings_on_trip_id", using: :btree
  add_index "lodgings", ["user_id"], name: "index_lodgings_on_user_id", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "group_id"
    t.string   "email"
    t.integer  "last_updated_by"
    t.boolean  "is_active",       default: false
    t.boolean  "is_admin",        default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "permissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "thing_id"
    t.string   "thing_type"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "poll_responses", force: true do |t|
    t.integer  "user_id"
    t.hstore   "choices"
    t.integer  "poll_id"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "poll_responses", ["poll_id"], name: "index_poll_responses_on_poll_id", using: :btree
  add_index "poll_responses", ["trip_id"], name: "index_poll_responses_on_trip_id", using: :btree
  add_index "poll_responses", ["user_id"], name: "index_poll_responses_on_user_id", using: :btree

  create_table "polls", force: true do |t|
    t.string   "title",                           null: false
    t.string   "poll_type",                       null: false
    t.date     "start_date"
    t.date     "end_date"
    t.string   "location"
    t.text     "generic_question"
    t.text     "notes"
    t.date     "expires"
    t.boolean  "is_active",        default: true
    t.integer  "trip_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "polls", ["trip_id"], name: "index_polls_on_trip_id", using: :btree
  add_index "polls", ["user_id"], name: "index_polls_on_user_id", using: :btree

  create_table "posts", force: true do |t|
    t.text     "message"
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["trip_id"], name: "index_posts_on_trip_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "rooms", force: true do |t|
    t.string   "name",             default: "",   null: false
    t.float    "price"
    t.integer  "min_stay"
    t.string   "room_type"
    t.text     "amenities"
    t.date     "deadline",                        null: false
    t.float    "deposit"
    t.boolean  "cc_required"
    t.integer  "min_age"
    t.string   "room_gender"
    t.text     "notes"
    t.integer  "sleeps"
    t.float    "price_per_person"
    t.boolean  "is_active",        default: true
    t.integer  "lodging_id"
    t.integer  "trip_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rooms", ["lodging_id"], name: "index_rooms_on_lodging_id", using: :btree
  add_index "rooms", ["trip_id"], name: "index_rooms_on_trip_id", using: :btree
  add_index "rooms", ["user_id"], name: "index_rooms_on_user_id", using: :btree

  create_table "rsvps", force: true do |t|
    t.string   "response",   null: false
    t.integer  "user_id"
    t.integer  "trip_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rsvps", ["trip_id"], name: "index_rsvps_on_trip_id", using: :btree
  add_index "rsvps", ["user_id"], name: "index_rsvps_on_user_id", using: :btree

  create_table "transportations", force: true do |t|
    t.string   "transportation_type", default: "",   null: false
    t.string   "service_number"
    t.string   "seat_number"
    t.float    "price"
    t.boolean  "deposit_required"
    t.text     "notes"
    t.string   "departure_city",      default: "",   null: false
    t.date     "departure_date"
    t.time     "departure_time"
    t.string   "arrival_city",        default: "",   null: false
    t.date     "arrival_date"
    t.time     "arrival_time"
    t.boolean  "is_active",           default: true
    t.integer  "trip_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transportations", ["trip_id"], name: "index_transportations_on_trip_id", using: :btree
  add_index "transportations", ["user_id"], name: "index_transportations_on_user_id", using: :btree

  create_table "trips", force: true do |t|
    t.string   "title",          default: "",    null: false
    t.string   "hash_tag"
    t.date     "start_date",                     null: false
    t.date     "end_date",                       null: false
    t.string   "location",       default: "",    null: false
    t.boolean  "is_private",     default: false
    t.boolean  "hide_guestlist", default: false
    t.boolean  "is_active",      default: true
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "trips", ["user_id"], name: "index_trips_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.boolean  "is_admin",               default: false
    t.string   "gender"
    t.string   "status"
    t.string   "zip_code"
    t.string   "mobile_number"
    t.string   "skype_id"
    t.string   "dietary_pref"
    t.string   "roommate_pref"
    t.boolean  "profile_updated",        default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "web_links", force: true do |t|
    t.integer  "user_id"
    t.string   "url",        default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "web_links", ["user_id"], name: "index_web_links_on_user_id", using: :btree

end
