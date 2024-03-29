require 'spec_helper'

module Ddr::Batch

  RSpec.describe Batch, type: :model, batch: true do

    let(:batch) { FactoryGirl.create(:batch_with_basic_ingest_batch_objects) }

    context "completed count" do
      before { batch.batch_objects.first.update_attributes(verified: true) }
      it "should return the number of verified batch objects" do
        expect(batch.completed_count).to eq(1)
      end
    end

    context "time to complete" do
      before do
        batch.batch_objects.first.update_attributes(verified: true)
        batch.update_attributes(processing_step_start: DateTime.now - 5.minutes)
      end
      it "should estimate the time to complete processing" do
        expect(batch.time_to_complete).to be_within(3).of(600)
      end
    end

    context "destroy" do
      before do
        batch.destroy
      end
      it "should destroy all the associated dependent objects" do
        expect(Ddr::Batch::Batch.all).to be_empty
        expect(Ddr::Batch::BatchObject.all).to be_empty
        expect(Ddr::Batch::BatchObjectDatastream.all).to be_empty
        expect(Ddr::Batch::BatchObjectRelationship.all).to be_empty
      end
    end
    
    context "validate" do
      let(:parent) { FactoryGirl.create(:test_parent) }
      let(:pid_cache) { { parent.pid => parent.class.name} }
      before do
        batch.batch_objects.each do |obj|
          obj.batch_object_relationships << 
              Ddr::Batch::BatchObjectRelationship.new(
                  :name => Ddr::Batch::BatchObjectRelationship::RELATIONSHIP_PARENT,
                  :object => parent.pid,
                  :object_type => Ddr::Batch::BatchObjectRelationship::OBJECT_TYPE_PID,
                  :operation => Ddr::Batch::BatchObjectRelationship::OPERATION_ADD
                  )
        end
      end
      it "should cache the results of looking up relationship objects" do
        expect(batch).to receive(:add_found_pid).once.with(parent.pid, "TestParent").and_call_original
        batch.validate
        expect(batch.found_pids).to eq(pid_cache)
      end
    end

  end

end
