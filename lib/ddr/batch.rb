require "ddr/batch/engine"
require "ddr/models"
require "devise"
require "paperclip"

module Ddr
  module Batch

    # Configuration for CSV
    mattr_accessor :csv_options

    # Yields an object with module configuration accessors
    def self.configure
      yield self
    end

  end
end