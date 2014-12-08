Rails.application.routes.draw do

  mount Ddr::Batch::Engine => "/"
  
  devise_for :users

end
