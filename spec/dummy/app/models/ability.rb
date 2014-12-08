class Ability < Ddr::Auth::Ability

  self.ability_logic += [ :batches_permissions, :ingest_folders_permissions, :metadata_files_permissions ]

  def batches_permissions
    can :manage, Ddr::Batch::Batch, :user_id => current_user.id
    can :manage, Ddr::Batch::BatchObject do |batch_object|
      can? :manage, batch_object.batch
    end
  end

  def ingest_folders_permissions
    can :create, Ddr::Batch::IngestFolder if Ddr::Batch::IngestFolder.permitted_folders(current_user).present?
    can [:show, :procezz], Ddr::Batch::IngestFolder, user: current_user
  end
  
  def metadata_files_permissions
    can [:show, :procezz], Ddr::Batch::MetadataFile, user: current_user
  end
  
end
