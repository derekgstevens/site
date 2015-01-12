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

ActiveRecord::Schema.define(version: 20150111235356) do

  create_table "days", force: :cascade do |t|
    t.datetime "day_date"
    t.integer  "year_id"
    t.integer  "month_id"
    t.integer  "min_slept"
    t.string   "sleep_title"
    t.integer  "sleep_quality"
    t.text     "sleep_snapshot_image"
    t.text     "step_snapshot_image"
    t.integer  "step_total"
    t.integer  "active_time"
    t.integer  "inactive_time"
    t.text     "storyline"
    t.text     "reports"
    t.string   "run_start"
    t.float    "run_total_distance"
    t.integer  "run_duration_min"
    t.integer  "run_duration_sec"
    t.integer  "day_rating"
    t.integer  "water_intake"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "commits"
  end

  create_table "months", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "dropbox_token"
    t.string   "moves_token"
    t.string   "healthgraph_token"
    t.string   "jawbone_token"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "years", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
