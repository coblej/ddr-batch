require 'spec_helper'

module Ddr
  module Batch

    RSpec.describe BatchesController, type: :controller, batch: true do
      
      routes { Ddr::Batch::Engine.routes }

      shared_examples "a delete-able batch" do
        it "should delete the batch and redirect to the index page" do
          delete :destroy, :id => batch
          expect(response).to redirect_to(Ddr::Batch::Engine.routes.url_helpers.batches_path)
          expect{ Ddr::Batch::Batch.find(batch.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
  
      shared_examples "a non-delete-able batch" do
        it "should not delete the batch and redirect to the index page" do
          delete :destroy, :id => batch
          expect(response).to redirect_to(Ddr::Batch::Engine.routes.url_helpers.batches_path)
          expect(Ddr::Batch::Batch.find(batch.id)).to eql(batch)
        end
      end

      describe "#destroy" do
        let(:batch) { FactoryGirl.create(:batch_with_basic_ingest_batch_objects) }
        before { sign_in batch.user }
        context "batch is pending (nil)" do
          it_behaves_like "a delete-able batch"
        end
        context "batch is validated" do
          before do
            batch.status = Ddr::Batch::Batch::STATUS_VALIDATED
            batch.save!
          end
          it_behaves_like "a delete-able batch"
        end
        context "batch is queued" do
          before do
            batch.status = Ddr::Batch::Batch::STATUS_QUEUED
            batch.save!
          end
          it_behaves_like "a non-delete-able batch"      
        end
        context "batch is running" do
          before do
            batch.status = Ddr::Batch::Batch::STATUS_RUNNING
            batch.save!
          end
          it_behaves_like "a non-delete-able batch"      
        end
        context "batch is finished" do
          before do
            batch.status = Ddr::Batch::Batch::STATUS_FINISHED
            batch.save!
          end
          it_behaves_like "a non-delete-able batch"      
        end
        context "batch is interrupted" do
          context "batch is not restartable" do
            before do
              batch.status = Ddr::Batch::Batch::STATUS_INTERRUPTED
              batch.save!
            end
            it_behaves_like "a non-delete-able batch"      
          end
          context "batch is restartable" do
            before do
              batch.status = Ddr::Batch::Batch::STATUS_RESTARTABLE
              batch.save!
            end
            it_behaves_like "a non-delete-able batch"      
          end
        end
      end

      describe "#procezz" do
        let(:batch) { FactoryGirl.create(:batch_with_basic_ingest_batch_objects) }
        before do
          sign_in batch.user
          get :procezz, :id => batch.id
          batch.reload
        end
        it "should set the status of the batch to QUEUED" do
          expect(response).to redirect_to(Ddr::Batch::Engine.routes.url_helpers.batches_path)
          expect(batch.status).to eq(Ddr::Batch::Batch::STATUS_QUEUED)
        end
      end

    end
  end
end