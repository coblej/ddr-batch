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

ActiveRecord::Schema.define(version: 20141205144531) do

  create_table "batch_object_datastreams", force: true do |t|
    t.integer  "batch_object_id"
    t.string   "operation"
    t.string   "name"
    t.text     "payload"
    t.string   "payload_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "checksum"
    t.string   "checksum_type"
  end

  create_table "batch_object_relationships", force: true do |t|
    t.integer  "batch_object_id"
    t.string   "name"
    t.string   "operation"
    t.string   "object"
    t.string   "object_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

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

  create_table "events", force: true do |t|
    t.datetime "event_date_time"
    t.integer  "user_id"
    t.string   "type"
    t.string   "pid"
    t.string   "software"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary"
    t.string   "outcome"
    t.text     "detail"
  end

  add_index "events", ["event_date_time"], name: "index_events_on_event_date_time"
  add_index "events", ["outcome"], name: "index_events_on_outcome"
  add_index "events", ["pid"], name: "index_events_on_pid"
  add_index "events", ["type"], name: "index_events_on_type"

  create_table "ingest_folders", force: true do |t|
    t.integer  "user_id"
    t.string   "base_path"
    t.string   "sub_path"
    t.string   "admin_policy_pid"
    t.string   "collection_pid"
    t.string   "model"
    t.string   "file_creator"
    t.string   "checksum_file"
    t.string   "checksum_type"
    t.boolean  "add_parents"
    t.integer  "parent_id_length"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "metadata_files", force: true do |t|
    t.integer  "user_id"
    t.string   "profile"
    t.string   "collection_pid"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "metadata_file_name"
    t.string   "metadata_content_type"
    t.integer  "metadata_file_size"
    t.datetime "metadata_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "username",               default: "", null: false
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "nickname"
    t.string   "last_name"
    t.string   "display_name"
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "workflow_states", force: true do |t|
    t.string   "pid"
    t.string   "workflow_state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "workflow_states", ["pid"], name: "index_workflow_states_on_pid", unique: true
  add_index "workflow_states", ["workflow_state"], name: "index_workflow_states_on_workflow_state"

end
