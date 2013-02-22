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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130222005856) do

  create_table "adjective_circles", :force => true do |t|
    t.string   "name_pair"
    t.string   "version"
    t.float    "size_weight"
    t.float    "size_sd"
    t.float    "size_mean"
    t.float    "distance_weight"
    t.float    "distance_sd"
    t.float    "distance_mean"
    t.float    "overlap_weight"
    t.float    "overlap_sd"
    t.float    "overlap_mean"
    t.string   "maps_to"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "assessments", :force => true do |t|
    t.date     "date_taken"
    t.string   "score"
    t.integer  "definition_id"
    t.integer  "user_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.text     "event_log"
    t.text     "intermediate_results"
    t.text     "stages"
    t.boolean  "results_ready"
    t.integer  "profile_description_id"
    t.text     "aggregate_results"
    t.string   "big5_dimension"
    t.string   "holland6_dimension"
    t.string   "emo8_dimension"
    t.integer  "stage_completed"
  end

  create_table "definitions", :force => true do |t|
    t.string   "name"
    t.text     "stages"
    t.text     "instructions"
    t.text     "end_remarks"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "experiment"
  end

  create_table "elements", :force => true do |t|
    t.string   "name"
    t.string   "version"
    t.float    "standard_deviation"
    t.float    "mean"
    t.float    "weight_extraversion"
    t.float    "weight_conscientiousness"
    t.float    "weight_neuroticism"
    t.float    "weight_openness"
    t.float    "weight_agreeableness"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "identities", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
  end

  add_index "identities", ["user_id"], :name => "index_identities_on_user_id"

  create_table "images", :force => true do |t|
    t.string   "name"
    t.text     "elements"
    t.string   "primary_color"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "profile_descriptions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "one_liner"
    t.text     "bullet_description"
    t.string   "big5_dimension"
    t.string   "holland6_dimension"
    t.string   "code"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "logo_url"
  end

  create_table "tidepool_identities", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "gender"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.boolean  "guest"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "gender"
    t.string   "email"
  end

end
