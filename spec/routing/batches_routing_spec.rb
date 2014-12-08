require 'spec_helper'

RSpec.describe "batches routing", type: :routing, batch: true do
  routes { Ddr::Batch::Engine.routes }
  describe "RESTful routes" do
    it "should have an index route" do
      @route = {controller: 'ddr/batch/batches', action: 'index'}
      expect(:get => '/batches').to route_to(@route)
      expect(:get => batches_path).to route_to(@route)
    end
    it "should have a show route" do
      @route = {controller: 'ddr/batch/batches', action: 'show', id: "1"}
      expect(:get => '/batches/1').to route_to(@route)
      expect(:get => batch_path(1)).to route_to(@route)
    end
    it "should have a destroy route" do
      @route = {controller: 'ddr/batch/batches', action: 'destroy', id: "1"}
      expect(:delete => '/batches/1').to route_to(@route)
      expect(:delete => batch_path(1)).to route_to(@route)
    end
  end
  describe "non-RESTful routes" do
    it "should have a route for validating a batch" do
      @route = {controller: 'ddr/batch/batches', action: 'validate', id: '1'} 
      expect(:get => 'batches/1/validate').to route_to(@route)
    end
    it "should have a route for processing a batch" do
      @route = {controller: 'ddr/batch/batches', action: 'procezz', id: '1'} 
      expect(:get => 'batches/1/procezz').to route_to(@route)
    end
  end
end
