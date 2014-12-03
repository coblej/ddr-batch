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

ActiveRecord::Schema.define(version: 20141203162233) do

  create_table "batch_objects", force: true do |t|
    t.integer  "batch_id"
    t.string   "identifier"
    t.string   "model"
    t.string   "label"
    t.string   "pid"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "type"
    t.boolean  "verified",   default: false
  end

  add_index "batch_objects", ["verified"], name: "index_batch_objects_on_verified"

  create_table "batches", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "user_id"
    t.string   "status"
    t.datetime "start"
    t.datetime "stop"
    t.string   "outcome"
    t.integer  "failure",               default: 0
    t.integer  "success",               default: 0
    t.string   "version"
    t.string   "logfile_file_name"
    t.string   "logfile_content_type"
    t.integer  "logfile_file_size"
    t.datetime "logfile_updated_at"
    t.datetime "processing_step_start"
  end

end
