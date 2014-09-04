Rails.application.routes.draw do

  devise_for :users, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'devise/registrations#update', :as => 'user_registration'
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  get 'export/history' => 'movements#history'
  post 'export/movements/update' => 'movements#update'
  post 'import/import_items/update' => 'import_items#update'
  get 'import/history' => 'import_items#history'
  get 'import/empty_containers' => 'import_items#empty_containers'

  # special inline edit for export_items
  post '/export_items/update'
  post '/movements/update'
  post 'customers/daily_report'
  post 'export_items/updatecontainer'
  post 'export_items/getcount'
  post '/imports/update'
  post '/import_items/update'
  resources :exports, only: [:new, :create, :index]
  resources :export_items, only: [:new, :create]
  resources :customers, only: [:new, :create]
  resources :imports, only: [:new ,:create ,:index] do
    member do
      post 'updateStatus'
    end
  end
  resources :import_items,only: [:new,:create,:index] do
    member do
      post 'updateStatus'
    end
  end
  resources :movements, only: [:new, :create, :index ] do
    member do
      post 'updateStatus'
    end
  end
  resources :imports, only: [:new, :create]
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
