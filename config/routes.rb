require 'sidekiq/web'
Rails.application.routes.draw do

  resources 'bills' do
    collection do
      match :get_container, via: :get
      match :get_number, via: :get
      match :load_vendor_charges, via: :get
      match :validate_item_number, via: :get
      match :validate_of_uniquness_format, via: :get
      match :validate_debit_note_number, via: :get
    end
  end

  mount Sidekiq::Web, at: "/sidekiq"

  resources 'vendors'
  match 'search_bills' => 'bills#search', as: 'bills_search', via: [:get, :post]
  #  readjustment payment made
  match '/paid/delete/Bill/:id' => 'bills#delete_ledger', via: [:delete]
  match '/paid/delete/DebitNote/:id' => 'debit_notes#delete_ledger', via: [:delete]
  match '/paid/delete/Payment/:id' => 'paid#delete_ledger', via: [:delete]

  # readjustment payment received
  match 'delete/Invoice/:id' => 'invoices#delete_ledger', via: [:delete]
  match 'delete/Payment/:id' => 'received#delete_ledger', via: [:delete]

  # readjust payments
  match '/payments/readjust/:id' => 'paid#readjust', as: :readjust, via: [:get]
  match '/payments/readjust/customer/:id' => 'received#readjust', as: :readjust_customer, via: [:get]

  # customer analysis
  match '/customer/analysis' => 'customers#analysis_report', as: :customer_analysis, via: [:get]
  match '/customer/analysis_margin_report' => 'customers#margin_analysis_report', as: :customer_margin_analysis, via: [:post, :get]

  resources :users, only: [:new, :index, :create, :update, :edit]

  devise_for :user, :skip => [:registrations]
  as :user do
    get 'user/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    put 'user' => 'devise/registrations#update', :as => 'user_registration'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  get 'export/history' => 'movements#history'
  post 'export/movements/update' => 'movements#update'
  post 'import/import_items/update' => 'import_items#update'
  match 'import/history' => 'import_items#history', :via => [:get, :post]
  get 'import/empty_containers' => 'import_items#empty_containers'
  get '/import_expenses/search' => "import_expenses#index"

  # special inline edit for export_items
  post 'exports/update'
  post '/export_items/update'
  post '/movements/update'
  post 'export_items/updatecontainer'
  post 'export_items/getcount'
  post '/imports/update'
  post '/import_items/update'
  get '/manual_invoices' => 'invoices#manual_invoices'
  get 'customer_ledger' => 'received#customer_ledger', as: 'customer_ledger'
  resources :bill_of_ladings, only: [:update] do
    collection do
      get 'search'
      match :change_bl_number, via: [:get, :post]
    end
  end

  resources :exports, only: [:new, :create, :index]
  resources :export_items, only: [:new, :create]
  resources :customers, only: [:new, :create, :index, :edit, :update] do
    collection do
      match :change_customer, via: [:get, :post]
    end
  end
  #post 'customers/create_new_customer' => 'customers#create_new_customer', as: :create_new_customer
  resources :imports do
    member do
      # post 'updateStatus'
      post 'retainStatus'
      get :edit_customer_modal
      patch :update_customer
    end
  end
  match '/edit_import_customer' => 'imports#edit_import_customer', via: [:get, :post]

  resources :audits, only: [:index] do
    member do
      get :audits_modal
    end
  end

  resources :shippings, only: [:index] do
    member do
      post 'update'
      post 'retainStatus'
      post 'late_document_mail'
      get 'fetch_shipping_modal'
      post 'update_column'
      # post 'updateStatus'
    end
  end

  resources :customs, only: [:index] do
    member do
      post 'update'
      post 'retainStatus'
      post 'update_column'
      post 'late_document_mail'
      get 'fetch_custom_modal'
      # post 'updateStatus'
    end
  end
  resources :import_items,only: [:new,:create,:index, :edit] do
    member do
      post 'updateStatus'
      post 'updateContext'
      get 'edit-close-date'
      post 'update-close-date'
      get 'show_info'
      get 'history_info'
      post 'update_empty_container'
      get 'location_dates_modal'
    end
    collection do
      post :update_loading_date
    end

    resource :import_expense, only: [:edit, :update, :destroy]
  end
  resources :movements, only: [:new, :create, :index, :edit] do
    member do
      post 'updateStatus'
      post 'retainStatus'
    end
  end
  resources :imports, only: [:new, :create]
  resources :paid, only: [:new, :show, :create, :index] do 
    collection do
      get :outstanding
    end
  end
  resources :received, only: [:new, :show, :create, :index] do
    collection do
      get :outstanding
      get 'fetch_form_partial', as:'fetch_form'
    end
  end
  resources :invoices, only: [:edit, :update] do
    collection do
      match :manual_entry, via: [:get, :post]
      get ':type', to: :index, as: :by_type
    end
    member do
      get 'add-additional-invoice' => "invoices#new_additional_invoice"
      post 'additional-invoice'
      get 'download'
      get 'send_invoice'
    end
  end
  resources :spare_parts do
    collection do
      get :load_sub_categories
      match :merge, via: [:get, :post]
      match :merge_content, via: [:get, :post]
      match :search, via: [:get, :post]
      match :undo_merge,  via: [:get,:post]
      match :history, via: [:get, :post]
    end
  end
  resources :req_sheets do
    collection do
      get :load_spare_part
      get :check_truck_type
    end
  end
  resources :trucks do
    collection do
      get :load_truck_numbers
      match :import_location, via: [:get, :post]
      post :download_location
      post :export_location
    end
  end
  resources :purchase_orders do
    collection do
      match :report, via: [:get, :post]
    end
    member do
      post :update_inv_number
    end
  end
  resources :suppliers
  resources :repair_heads
  resources :job_cards
  get '/coming_soon' => "welcome#coming_soon"
  resources :expense_heads, except: :destroy
  resources :petty_cashes, except: [:destroy, :edit, :update]
  get '/tabular_partial' => 'petty_cashes#tabular_partial'
  resources :fuel_entries, except: [:destroy, :edit, :update]
  get '/mpesaes' => 'petty_cashes#mpesaes', as: 'mpesaes'
  get '/mpesaes/new' => 'petty_cashes#new', as: 'new_mpesaes'
  get '/petty_cash_nbos' => 'petty_cashes#petty_cash_nbos', as: 'petty_cash_nbos'
  get '/petty_cash_nbos/new' => 'petty_cashes#new', as: 'new_petty_cash_nbos'
  resources :remarks
  resources :mechanics
  resources :breakdown_reasons
  resources :breakdown_managements
  resources :freezpls
  resources :truck_pls
  resources :spare_part_ledgers do
    collection do
     match :readjust, via: [:get]
    end
  end
  get 'reports/vendor_invoices' => 'reports#vendor_invoices'
  get 'reports/customer_invoices' => 'reports#customer_invoices'
  get 'reports/payments_made' => 'reports#payments_made'
  get 'reports/payments_received' => 'reports#payments_received'
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
