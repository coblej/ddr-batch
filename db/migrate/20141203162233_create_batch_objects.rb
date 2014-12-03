class CreateBatchObjects < ActiveRecord::Migration
  def up
    unless table_exists?("batch_objects")
      create_table "batch_objects" do |t|
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
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
