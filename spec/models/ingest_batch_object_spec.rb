require 'spec_helper'

module Ddr::Batch

  RSpec.shared_examples "a valid ingest object" do
    it "should be valid" do
      expect(object.validate).to be_empty
    end
  end
  
  RSpec.shared_examples "an invalid ingest object" do
    it "should not be valid" do
      expect(object.validate).to include(error_message)
    end
  end
  
  RSpec.shared_examples "a successful ingest" do
    before { object.process(user) }      
    it "should result in a verified repository object" do
      expect(object.verified).to be_truthy
      expect(object.pid).to eq(assigned_pid) if assigned_pid.present?
      expect(ActiveFedora::Base.find(object.pid).title).to eq(["Test Object Title"])
    end
  end
  
  RSpec.describe IngestBatchObject, type: :model, batch: true, ingest: true do

    before do
      allow(File).to receive(:readable?).and_call_original
      allow(File).to receive(:readable?).with("/tmp/qdc-rdf.nt").and_return(true)
    end

    context "validate" do
    
      context "valid object" do
        context "generic object" do
          let(:object) { FactoryGirl.create(:generic_ingest_batch_object_with_bytes, :has_batch) }
          it_behaves_like "a valid ingest object"
        end
        context "target object" do
          let(:object) { FactoryGirl.create(:target_ingest_batch_object, :has_batch) }
          it_behaves_like "a valid ingest object"
        end
        context "object related to an uncreated object with pre-assigned PID" do
          let(:object) { FactoryGirl.create(:generic_ingest_batch_object_with_bytes) }
          let(:parent) { FactoryGirl.create(:generic_ingest_batch_object_with_bytes) }
          let(:parent_pid) { 'test:4321' }
          let(:batch) { FactoryGirl.create(:batch) }
          let(:relationship) do
            Ddr::Batch::BatchObjectRelationship.create(
              :name => Ddr::Batch::BatchObjectRelationship::RELATIONSHIP_PARENT,
              :object => parent_pid,
              :object_type => Ddr::Batch::BatchObjectRelationship::OBJECT_TYPE_PID,
              :operation => Ddr::Batch::BatchObjectRelationship::OPERATION_ADD
              )
          end
          before do
            object.batch = batch
            object.batch_object_relationships << relationship
            object.save
            parent.batch = batch
            parent.pid = parent_pid
            parent.save
          end
          it_behaves_like "a valid ingest object"
        end
      end
  
      context "invalid object" do
        let(:error_prefix) { "#{object.identifier} [Database ID: #{object.id}]:"}
        context "missing model" do
          let(:object) { FactoryGirl.create(:ingest_batch_object) }
          let(:error_message) { "#{error_prefix} Model required for INGEST operation" }
          it_behaves_like "an invalid ingest object"
        end
        context "invalid model" do
          let(:object) { FactoryGirl.create(:ingest_batch_object) }
          let(:error_message) { "#{error_prefix} Invalid model name: #{object.model}" }
          before { object.model = "BadModel" }
          it_behaves_like "an invalid ingest object"
        end
        context "pre-assigned pid already exists" do
          let(:object) { FactoryGirl.create(:ingest_batch_object, :has_model) }
          let(:existing_object) { FactoryGirl.create(:test_model) }
          let(:error_message) { "#{error_prefix} #{existing_object.pid} already exists in repository" }
          before { object.pid = existing_object.pid }
          it_behaves_like "an invalid ingest object"
        end
        context "invalid admin policy" do
          let(:object) { FactoryGirl.create(:ingest_batch_object, :has_batch, :has_model) }
          context "admin policy pid object does not exist" do
            let(:admin_policy_pid) { "bogus:AdminPolicy" }
            let(:error_message) { "#{error_prefix} admin_policy relationship object does not exist: #{admin_policy_pid}" }
            before do
              relationship = FactoryGirl.create(:batch_object_add_relationship, :name => "admin_policy", :object => admin_policy_pid, :object_type => BatchObjectRelationship::OBJECT_TYPE_PID)
              object.batch_object_relationships << relationship
              object.save
            end
            it_behaves_like "an invalid ingest object"
          end
          context "admin policy pid object exists but is not admin policy" do
            let(:error_message) { "#{error_prefix} admin_policy relationship object #{@not_admin_policy.pid} exists but is not a(n) Collection" }
            before do
              @not_admin_policy = FactoryGirl.create(:test_model)
              relationship = FactoryGirl.create(:batch_object_add_relationship, :name => "admin_policy", :object => @not_admin_policy.pid, :object_type => BatchObjectRelationship::OBJECT_TYPE_PID)
              object.batch_object_relationships << relationship
              object.save
            end
            it_behaves_like "an invalid ingest object"
          end
        end
        context "invalid datastreams" do
          let(:object) { FactoryGirl.create(:ingest_batch_object, :has_model, :with_add_desc_metadata_datastream_bytes, :with_add_content_datastream) }
          context "invalid datastream name" do
            let(:error_message) { "#{error_prefix} Invalid datastream name for #{object.model}: #{object.batch_object_datastreams.first[:name]}" }
            before do
              datastream = object.batch_object_datastreams.first
              datastream.name = "invalid_name"
              datastream.save!
            end
            it_behaves_like "an invalid ingest object"
          end
          context "invalid payload type" do
            let(:error_message) { "#{error_prefix} Invalid payload type for #{object.batch_object_datastreams.first[:name]} datastream: #{object.batch_object_datastreams.first[:payload_type]}" }
            before do
              datastream = object.batch_object_datastreams.first
              datastream.payload_type = "invalid_type"
              datastream.save!
            end
            it_behaves_like "an invalid ingest object"
          end
          context "missing data file" do
            let(:error_message) { "#{error_prefix} Missing or unreadable file for #{object.batch_object_datastreams.last[:name]} datastream: #{object.batch_object_datastreams.last[:payload]}" }
            before do
              datastream = object.batch_object_datastreams.last
              datastream.payload = "non_existent_file.xml"
              datastream.save!
            end
            it_behaves_like "an invalid ingest object"
          end
          context "checksum without checksum type" do
            let(:error_message) { "#{error_prefix} Must specify checksum type if providing checksum for #{object.batch_object_datastreams.first.name} datastream" }
            before do
              datastream = object.batch_object_datastreams.first
              datastream.checksum = "123456"
              datastream.checksum_type = nil
              datastream.save!
            end
            it_behaves_like "an invalid ingest object"
          end
          context "invalid checksum type" do
            let(:error_message) { "#{error_prefix} Invalid checksum type for #{object.batch_object_datastreams.first.name} datastream: #{object.batch_object_datastreams.first.checksum_type}" }
            before do
              datastream = object.batch_object_datastreams.first
              datastream.checksum_type = "SHA-INVALID"
              datastream.save!
            end
            it_behaves_like "an invalid ingest object"
          end
        end
        context "invalid parent" do
          let(:object) { FactoryGirl.create(:ingest_batch_object, :has_batch, :has_model) }
          context "parent pid object does not exist" do
            let(:parent_pid) { "bogus:TestParent" }
            let(:error_message) { "#{error_prefix} parent relationship object does not exist: #{parent_pid}" }
            before do
              relationship = FactoryGirl.create(:batch_object_add_relationship, :name => "parent", :object => parent_pid, :object_type => BatchObjectRelationship::OBJECT_TYPE_PID)
              object.batch_object_relationships << relationship
              object.save
            end
            it_behaves_like "an invalid ingest object"
          end
          context "parent pid object exists but is not correct parent object type" do
            let(:error_message) { "#{error_prefix} parent relationship object #{@not_parent.pid} exists but is not a(n) TestParent" }
            before do
              @not_parent = FactoryGirl.create(:test_model)
              relationship = FactoryGirl.create(:batch_object_add_relationship, :name => "parent", :object => @not_parent.pid, :object_type => BatchObjectRelationship::OBJECT_TYPE_PID)
              object.batch_object_relationships << relationship
              object.save
            end
            it_behaves_like "an invalid ingest object"
          end
        end
        context "invalid target_for" do
          let(:object) { FactoryGirl.create(:ingest_batch_object, :has_batch) }
          context "target_for pid object does not exist" do
            let(:collection_pid) { "bogus:Collection" }
            let(:error_message) { "#{error_prefix} collection relationship object does not exist: #{collection_pid}" }
            before do
              object.model = "Target"
              relationship = FactoryGirl.create(:batch_object_add_relationship, :name => "collection", :object => collection_pid, :object_type => BatchObjectRelationship::OBJECT_TYPE_PID)
              object.batch_object_relationships << relationship
              object.save
            end
            it_behaves_like "an invalid ingest object"
          end
          context "target_for pid object exists but is not collection" do
            let(:error_message) { "#{error_prefix} collection relationship object #{@not_collection.pid} exists but is not a(n) Collection" }
            before do
              @not_collection = FactoryGirl.create(:test_model)
              object.model = "Target"
              relationship = FactoryGirl.create(:batch_object_add_relationship, :name => "collection", :object => @not_collection.pid, :object_type => BatchObjectRelationship::OBJECT_TYPE_PID)
              object.batch_object_relationships << relationship
              object.save
            end
            it_behaves_like "an invalid ingest object"
          end
        end
      end
    end
  
    context "ingest" do
      
      let(:user) { FactoryGirl.create(:user) }
      context "successful ingest" do
        context "object without a pre-assigned PID" do
          let(:assigned_pid) { nil }
          context "payload type bytes" do
            let(:object) { FactoryGirl.create(:generic_ingest_batch_object_with_bytes) }
            it_behaves_like "a successful ingest"
          end
          context "payload type file" do
            let(:object) { FactoryGirl.create(:generic_ingest_batch_object_with_file) }
            before { allow(File).to receive(:read).with('/tmp/qdc-rdf.nt').and_return('_:test <http://purl.org/dc/terms/title> "Test Object Title" .') }
            it_behaves_like "a successful ingest"
          end
        end
        context "object with a pre-assigned PID" do
          let(:object) { FactoryGirl.create(:generic_ingest_batch_object_with_bytes) }
          let(:assigned_pid) { 'test:6543' }
          before do
            object.pid = assigned_pid
            object.save
          end
          it_behaves_like "a successful ingest"
        end
        context "previously ingested object (e.g., during restart)" do
          let(:object) { FactoryGirl.create(:generic_ingest_batch_object_with_bytes) }
          let(:assigned_pid) { 'test:6543' }
          before do
            object.pid = assigned_pid
            object.verified = true
            object.save
            repo_object = object.model.constantize.new(:pid => assigned_pid, title: ["Test Object Title"])
            repo_object.save(validate: false)
          end
          it_behaves_like "a successful ingest"          
        end
      end
      
      context "exception during ingest" do
        let(:object) { FactoryGirl.create(:generic_ingest_batch_object_with_bytes) }
        before { allow_any_instance_of(Ddr::Batch::IngestBatchObject).to receive(:populate_datastream).and_raise(RuntimeError) }
        context "error during processing" do
          it "should log a fatal message and re-raise the exception" do
            expect(Rails.logger).to receive(:fatal).with(/Error in creating repository object/)
            expect { object.process(user) }.to raise_error(RuntimeError)
          end
        end
        context "error while destroying repository object" do
          before { allow_any_instance_of(TestModelOmnibus).to receive(:destroy).and_raise(RuntimeError) }
          after { allow_any_instance_of(TestModelOmnibus).to receive(:destroy).and_call_original }
          it "should log two fatal messages and re-raise the initial exception" do
            expect(Rails.logger).to receive(:fatal).with(/Error in creating repository object/)
            expect(Rails.logger).to receive(:fatal).with(/Error deleting repository object/)
            expect { object.process(user) }.to raise_error(RuntimeError)
          end
        end
      end
      
      context "external checksum verification failure" do
        let(:object) { FactoryGirl.create(:generic_ingest_batch_object_with_bytes) }
        before do
          object.batch_object_datastreams.each do |ds|
            if ds.name == "content"
              ds.checksum = "badabcdef0123456789"
              object.save!
            end
          end
        end
        it "should not result in a verified ingest" do
          object.process(user)
          expect(object.verified).to be_falsey
          ActiveFedora::Base.find(object.pid).events.each do |e|
            if e.is_a?(Ddr::Events::ValidationEvent)
              expect(e.outcome).to eq(Ddr::Events::Event::FAILURE)
              expect(e.detail).to include("content external checksum match...FAIL")
            end
          end
        end
      end

    end
      
  end

end
