class CreateMetadataFiles < ActiveRecord::Migration
  def up
    unless table_exists?("metadata_files")
      create_table "metadata_files" do |t|
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
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
