class User < ActiveRecord::Base

  include Ddr::Auth::User
  
  has_many :batches, inverse_of: :user, class_name: Ddr::Batch::Batch

end