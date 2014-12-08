Ddr::Batch::Engine.routes.draw do
  
  resources :batches, controller: 'ddr/batch/batches', only: [ :index, :show, :destroy ] do
    member do
      get 'procezz'
      get 'validate'
    end
    resources :batch_objects, controller: 'ddr/batch/batch_objects', only: :index
  end

  resources :batch_objects, controller: 'ddr/batch/batch_objects', only: :show do
    resources :batch_object_datastreams, :only => :index
    resources :batch_object_relationships, :only => :index
  end

  resources :ingest_folders, controller: 'ddr/batch/ingest_folders', only: [ :new, :create, :show ] do
    member do
      get 'procezz'
    end
  end

  resources :metadata_files, controller: 'ddr/batch/metadata_files', only: [ :new, :create, :show ] do
    member do
      get 'procezz'
    end
  end

end
