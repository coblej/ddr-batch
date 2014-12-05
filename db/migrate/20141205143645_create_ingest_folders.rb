class CreateIngestFolders < ActiveRecord::Migration
  def up
    unless table_exists?("ingest_folders")
      create_table "ingest_folders" do |t|
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
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
