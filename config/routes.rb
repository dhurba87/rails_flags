RailsFlags::Engine.routes.draw do
  get "/admin", to: "admin#index", as: :admin
  post "/admin/create", to: "admin#create", as: :admin_create
  patch "/admin/:name", to: "admin#update", as: :admin_update
  delete "/admin/:name", to: "admin#destroy", as: :admin_delete

  root to: "admin#index"
end
