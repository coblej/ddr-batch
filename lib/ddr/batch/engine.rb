require 'rails'

module Ddr
  module Batch
    class Engine < ::Rails::Engine
      engine_name "ddr_batch"

      initializer "ddr_batch.metadata_file" do
        Ddr::Batch.csv_options = { 
          encoding: "UTF-8",
          col_sep: "\t",
          headers: true,
          write_headers: true,
          header_converters: :symbol
        }
      end
    end
  end
end
