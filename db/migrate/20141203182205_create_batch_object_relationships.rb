class CreateBatchObjectRelationships < ActiveRecord::Migration
  def up
    unless table_exists?("batch_object_relationships")
      create_table "batch_object_relationships" do |t|
        t.integer  "batch_object_id"
        t.string   "name"
        t.string   "operation"
        t.string   "object"
        t.string   "object_type"
        t.datetime "created_at",      null: false
        t.datetime "updated_at",      null: false
      end
    end
  end
  
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
