class User < ActiveRecord::Base

  include Ddr::Auth::User
  
  has_many :batches, inverse_of: :user, class_name: Ddr::Batch::Batch
  has_many :ingest_folders, inverse_of: :user, class_name: Ddr::Batch::IngestFolder
  has_many :metadata_files, inverse_of: :user, class_name: Ddr::Batch::MetadataFile

end