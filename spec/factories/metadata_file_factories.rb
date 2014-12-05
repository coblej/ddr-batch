FactoryGirl.define do
  
  factory :metadata_file, class: Ddr::Batch::MetadataFile do
    user { FactoryGirl.create(:user) }
    
    factory :metadata_file_descmd_csv do
      metadata { File.new(File.join(Ddr::Batch::Engine.root.to_s, 'spec', 'fixtures', 'descmd_csv.csv')) }
      profile { File.join(Ddr::Batch::Engine.root.to_s, 'spec', 'fixtures', 'DESCMD_CSV.yml') }
    end
    
    factory :metadata_file_mapped_tab do
      metadata { File.new(File.join(Ddr::Batch::Engine.root.to_s,'spec', 'fixtures', 'mapped_tab.txt')) }
      profile { File.join(Ddr::Batch::Engine.root.to_s, 'spec', 'fixtures', 'mapped_tab.yml') }
    end
    
  end
  
end



