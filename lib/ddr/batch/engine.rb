require 'rails'

module Ddr
  module Batch
    class Engine < ::Rails::Engine

      engine_name "ddr_batch"

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_girl
      end

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
