FactoryGirl.define do

  factory :component do
    title [ "Test Component" ]
    sequence(:identifier) { |n| [ "cmp%05d" % n ] }
    after(:build) do |c|
      c.upload File.new(File.join(Ddr::Batch::Engine.root.to_s, "spec", "fixtures", "library-devil.tiff"))
    end
        
    trait :has_parent do
      item
    end
    
  end
end
