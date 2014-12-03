class CreateBatchObjectDatastreams < ActiveRecord::Migration
  def up
    unless table_exists?("batch_object_datastreams")
      create_table "batch_object_datastreams" do |t|
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
    end
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end