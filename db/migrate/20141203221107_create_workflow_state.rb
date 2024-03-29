class CreateWorkflowState < ActiveRecord::Migration
  def up
    unless table_exists?("workflow_states")
      create_table "workflow_states" do |t|
        t.string   "pid"
        t.string   "workflow_state"
        t.datetime "created_at"
        t.datetime "updated_at"
      end

      add_index "workflow_states", ["pid"], name: "index_workflow_states_on_pid", unique: true
      add_index "workflow_states", ["workflow_state"], name: "index_workflow_states_on_workflow_state"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end