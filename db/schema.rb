# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100907122837) do

  create_table "accommodations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organisation_id"
    t.string   "type"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "post_code"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "status"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "contacted_user_id"
    t.string   "description"
    t.date     "when"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["contacted_user_id", "created_at"], :name => "index_contacts_on_contacted_user_id_and_created_at"
  add_index "contacts", ["user_id", "created_at"], :name => "index_contacts_on_user_id_and_created_at"

  create_table "individual_post_preferred_countries", :force => true do |t|
    t.integer  "individual_post_id", :null => false
    t.integer  "country_id",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "individual_posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "kind"
    t.string   "when"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "locale"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.text     "message"
    t.datetime "date"
    t.boolean  "read",       :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organisation_post_spoken_languages", :force => true do |t|
    t.integer  "organisation_post_id", :null => false
    t.integer  "language_id",          :null => false
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organisation_posts", :force => true do |t|
    t.integer  "organisation_id",   :null => false
    t.integer  "user_id",           :null => false
    t.string   "category"
    t.string   "area"
    t.integer  "duration"
    t.date     "when"
    t.text     "short_description"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organisations", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "homepage"
    t.string   "city"
    t.string   "street"
    t.string   "state"
    t.string   "post_code"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat",            :default => 0.0, :null => false
    t.float    "lng",            :default => 0.0, :null => false
    t.string   "teh_membership", :default => "",  :null => false
    t.string   "teh_link"
    t.integer  "view_counter",   :default => 0
    t.string   "facebook_link"
    t.string   "image_link"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_spoken_languages", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.integer  "language_id", :null => false
    t.integer  "rank"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.integer  "organisation_id"
    t.integer  "uid",                               :limit => 8,                     :null => false
    t.integer  "signup_step",                                    :default => 0
    t.boolean  "is_admin",                                       :default => false,  :null => false
    t.string   "session_key"
    t.string   "session_expires"
    t.string   "gender"
    t.integer  "age"
    t.string   "city"
    t.string   "street",                                         :default => "",     :null => false
    t.string   "state"
    t.string   "post_code"
    t.string   "country"
    t.string   "job_area"
    t.string   "job_role"
    t.text     "job_description"
    t.integer  "go_as_worker"
    t.integer  "go_as_volunteer"
    t.integer  "go_as_intern"
    t.integer  "go_as_visitor"
    t.text     "go_info"
    t.string   "hosting"
    t.string   "infopoint"
    t.datetime "last_access"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "lat",                                            :default => 0.0,    :null => false
    t.float    "lng",                                            :default => 0.0,    :null => false
    t.string   "is_my_app_user",                                 :default => "0",    :null => false
    t.string   "cached_name",                                    :default => "",     :null => false
    t.string   "cached_profile_url",                             :default => "",     :null => false
    t.string   "cached_pic_square",                              :default => "",     :null => false
    t.integer  "birthday_day",                                   :default => 0
    t.integer  "birthday_month",                                 :default => 0
    t.integer  "view_counter",                                   :default => 0
    t.string   "twitter",                                        :default => ""
    t.string   "linkedin",                                       :default => ""
    t.boolean  "cached_belongs_to_admission_group",              :default => false
    t.datetime "last_signup_step_at"
    t.string   "email"
    t.boolean  "email_privacy",                                  :default => false
    t.string   "notification_by_email_every",                    :default => "week"
    t.boolean  "notify_match",                                   :default => true
    t.boolean  "notify_colleague",                               :default => true
    t.boolean  "notify_notifications_for_all",                   :default => false
    t.boolean  "is_board_member"
    t.boolean  "is_boss"
    t.boolean  "is_manager"
    t.integer  "hours_as_worker"
    t.integer  "hours_as_volunteer"
    t.boolean  "is_approved",                                    :default => false
  end

  add_index "users", ["organisation_id", "created_at"], :name => "index_users_on_organisation_id_and_created_at"
  add_index "users", ["signup_step"], :name => "index_users_on_signup_step"
  add_index "users", ["uid"], :name => "index_users_on_uid"

  create_table "visits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "organisation_id"
    t.string   "description"
    t.date     "when"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "visits", ["organisation_id", "created_at"], :name => "index_visits_on_organisation_id_and_created_at"
  add_index "visits", ["user_id", "created_at"], :name => "index_visits_on_user_id_and_created_at"

end
