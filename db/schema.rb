# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210615072737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bill_items", force: true do |t|
    t.integer  "serial_number"
    t.string   "item_type"
    t.integer  "bill_id"
    t.date     "bill_date"
    t.integer  "vendor_id"
    t.string   "item_for"
    t.text     "item_number"
    t.text     "charge_for"
    t.integer  "quantity"
    t.float    "rate"
    t.float    "line_amount"
    t.integer  "activity_id"
    t.string   "activity_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_items", ["activity_id", "activity_type"], name: "index_bill_items_on_activity_id_and_activity_type", using: :btree

  create_table "bill_of_ladings", force: true do |t|
    t.string   "bl_number"
    t.string   "payment_ocean"
    t.string   "cheque_ocean"
    t.string   "payment_clearing"
    t.string   "cheque_clearing"
    t.string   "remarks"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "agency_fee"
    t.string   "shipping_line_charges"
  end

  add_index "bill_of_ladings", ["bl_number"], name: "index_bill_of_ladings_on_bl_number", using: :btree

  create_table "bills", force: true do |t|
    t.text     "bill_number"
    t.date     "bill_date"
    t.integer  "vendor_id"
    t.float    "value"
    t.text     "remark"
    t.integer  "created_by_id"
    t.integer  "approved_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency"
  end

  create_table "breakdown_managements", force: true do |t|
    t.date     "date"
    t.text     "remark"
    t.string   "location"
    t.integer  "mechanic_id"
    t.integer  "truck_id"
    t.string   "status"
    t.boolean  "parts_required"
    t.date     "sending_date"
    t.integer  "breakdown_reason_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "close_date"
  end

  add_index "breakdown_managements", ["date"], name: "index_breakdown_managements_on_date", using: :btree
  add_index "breakdown_managements", ["status"], name: "index_breakdown_managements_on_status", using: :btree

  create_table "breakdown_reasons", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "emails"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sales_rep_name"
    t.string   "account_emails"
    t.string   "operation_emails"
    t.string   "management_emails"
  end

  create_table "debit_notes", force: true do |t|
    t.string   "reason"
    t.float    "amount"
    t.integer  "bill_id"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "number"
    t.string   "debit_note_for"
    t.string   "currency"
  end

  add_index "debit_notes", ["bill_id"], name: "index_debit_notes_on_bill_id", using: :btree
  add_index "debit_notes", ["vendor_id"], name: "index_debit_notes_on_vendor_id", using: :btree

  create_table "espinita_audits", force: true do |t|
    t.integer  "auditable_id"
    t.string   "auditable_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.text     "audited_changes"
    t.string   "comment"
    t.integer  "version"
    t.string   "action"
    t.string   "remote_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "espinita_audits", ["auditable_id", "auditable_type"], name: "index_espinita_audits_on_auditable_id_and_auditable_type", using: :btree
  add_index "espinita_audits", ["user_id", "user_type"], name: "index_espinita_audits_on_user_id_and_user_type", using: :btree

  create_table "expense_heads", force: true do |t|
    t.string   "name"
    t.boolean  "is_related_to_truck", default: false
    t.boolean  "is_active",           default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "export_items", force: true do |t|
    t.string   "container"
    t.string   "location"
    t.string   "weight"
    t.integer  "export_id"
    t.integer  "movement_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date_of_placement"
  end

  add_index "export_items", ["export_id"], name: "index_export_items_on_export_id", using: :btree

  create_table "exports", force: true do |t|
    t.string   "equipment"
    t.integer  "quantity"
    t.string   "export_type"
    t.string   "shipping_line_name"
    t.integer  "placed"
    t.string   "release_order_number"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "moved"
    t.integer  "shipping_line_id"
  end

  add_index "exports", ["customer_id"], name: "index_exports_on_customer_id", using: :btree

  create_table "freezpls", force: true do |t|
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fuel_entries", force: true do |t|
    t.float    "quantity"
    t.float    "cost"
    t.date     "date"
    t.float    "available"
    t.boolean  "is_adjustment"
    t.integer  "truck_id"
    t.string   "office_vehicle"
    t.string   "purchased_dispensed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fuel_entries", ["truck_id"], name: "index_fuel_entries_on_truck_id", using: :btree

  create_table "fuel_stocks", force: true do |t|
    t.float    "quantity"
    t.float    "rate"
    t.date     "date"
    t.float    "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "import_expenses", force: true do |t|
    t.integer  "import_item_id"
    t.string   "category"
    t.string   "name"
    t.string   "amount"
    t.string   "currency"
    t.string   "invoice_date"
    t.string   "delivery_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invoice_number"
  end

  add_index "import_expenses", ["import_item_id"], name: "index_import_expenses_on_import_item_id", using: :btree

  create_table "import_items", force: true do |t|
    t.string   "container_number"
    t.string   "trailer_number"
    t.string   "tr_code"
    t.string   "truck_number"
    t.string   "current_location"
    t.string   "bond_direction"
    t.string   "bond_number"
    t.string   "status"
    t.integer  "import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remark"
    t.string   "yard_name"
    t.datetime "g_f_expiry"
    t.datetime "close_date"
    t.string   "after_delivery_status"
    t.string   "context"
    t.integer  "vendor_id"
    t.integer  "truck_id"
    t.datetime "last_loading_date"
    t.boolean  "exit_note_received",         default: false
    t.string   "dropped_location"
    t.integer  "return_status"
    t.date     "expiry_date"
    t.boolean  "is_co_loaded",               default: false
    t.string   "interchange_number"
    t.date     "tentative_truck_allocation"
    t.integer  "next_truck_id"
    t.string   "equipment"
    t.integer  "item_quantity",              default: 0
    t.float    "item_weight",                default: 0.0
  end

  add_index "import_items", ["container_number"], name: "index_import_items_on_container_number", using: :btree
  add_index "import_items", ["exit_note_received"], name: "index_import_items_on_exit_note_received", using: :btree
  add_index "import_items", ["expiry_date"], name: "index_import_items_on_expiry_date", using: :btree
  add_index "import_items", ["import_id"], name: "index_import_items_on_import_id", using: :btree
  add_index "import_items", ["is_co_loaded"], name: "index_import_items_on_is_co_loaded", using: :btree
  add_index "import_items", ["next_truck_id"], name: "index_import_items_on_next_truck_id", using: :btree
  add_index "import_items", ["status"], name: "index_import_items_on_status", using: :btree
  add_index "import_items", ["tentative_truck_allocation"], name: "index_import_items_on_tentative_truck_allocation", using: :btree
  add_index "import_items", ["truck_id"], name: "index_import_items_on_truck_id", using: :btree
  add_index "import_items", ["truck_number"], name: "index_import_items_on_truck_number", using: :btree
  add_index "import_items", ["vendor_id"], name: "index_import_items_on_vendor_id", using: :btree

  create_table "imports", force: true do |t|
    t.string   "equipment"
    t.integer  "quantity"
    t.string   "from"
    t.string   "to"
    t.string   "bl_number"
    t.date     "estimate_arrival"
    t.string   "description"
    t.string   "rate"
    t.string   "status"
    t.date     "out_of_port_date"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shipping_line_name"
    t.string   "work_order_number"
    t.string   "remark"
    t.string   "clearing_agent"
    t.string   "bill_of_lading_id"
    t.string   "rate_agreed"
    t.string   "weight"
    t.integer  "clearing_agent_id"
    t.integer  "shipping_line_id"
    t.boolean  "is_all_container_delivered", default: false
    t.string   "entry_number"
    t.string   "shipper"
    t.integer  "bl_received_type"
    t.string   "consignee_name"
    t.date     "bl_received_at"
    t.date     "charges_received_at"
    t.date     "charges_paid_at"
    t.date     "do_received_at"
    t.date     "pl_received_at"
    t.date     "gf_return_date"
    t.string   "return_location"
    t.boolean  "is_late_submission"
    t.string   "rotation_number"
    t.integer  "entry_type"
    t.date     "entry_date"
    t.integer  "item_quantity",              default: 1
    t.float    "remaining_quantity",         default: 0.0
    t.float    "remaining_weight",           default: 0.0
    t.string   "order_type",                 default: "Normal"
  end

  add_index "imports", ["bill_of_lading_id"], name: "index_imports_on_bill_of_lading_id", using: :btree
  add_index "imports", ["bl_number"], name: "index_imports_on_bl_number", using: :btree
  add_index "imports", ["bl_received_at"], name: "index_imports_on_bl_received_at", using: :btree
  add_index "imports", ["clearing_agent_id"], name: "index_imports_on_clearing_agent_id", using: :btree
  add_index "imports", ["created_at"], name: "index_imports_on_created_at", using: :btree
  add_index "imports", ["customer_id"], name: "index_imports_on_customer_id", using: :btree
  add_index "imports", ["entry_type"], name: "index_imports_on_entry_type", using: :btree

  create_table "invoices", force: true do |t|
    t.string   "number"
    t.date     "date"
    t.string   "document_number"
    t.integer  "amount",              default: 0
    t.string   "status"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "previous_invoice_id"
    t.integer  "invoiceable_id"
    t.string   "invoiceable_type"
    t.string   "legacy_bl"
    t.text     "remarks"
    t.boolean  "manual",              default: false
  end

  create_table "job_card_details", force: true do |t|
    t.integer  "repair_head_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "job_card_id"
  end

  create_table "job_cards", force: true do |t|
    t.date     "date"
    t.string   "number"
    t.integer  "truck_id"
    t.integer  "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "job_cards", ["date"], name: "index_job_cards_on_date", using: :btree

  create_table "ledgers", force: true do |t|
    t.integer  "customer_id"
    t.integer  "voucher_id"
    t.string   "voucher_type"
    t.integer  "amount"
    t.integer  "received"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "local_import_items", force: true do |t|
    t.date     "offloading_date"
    t.string   "container_number"
    t.string   "status"
    t.string   "truck"
    t.integer  "local_import_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "local_import_items", ["local_import_id"], name: "index_local_import_items_on_local_import_id", using: :btree

  create_table "local_imports", force: true do |t|
    t.string   "bl_number"
    t.string   "description"
    t.string   "shipper"
    t.string   "equipment_type"
    t.integer  "quantity"
    t.boolean  "exemption_code_needed"
    t.boolean  "kebs_exemption_code_needed"
    t.string   "vessel_name"
    t.date     "estimated_arrival"
    t.string   "gwt"
    t.string   "fpd"
    t.string   "idf_number"
    t.date     "idf_date"
    t.string   "invoice_number"
    t.string   "reference_number"
    t.date     "reference_date"
    t.string   "customer_reference"
    t.string   "status"
    t.integer  "customer_id"
    t.integer  "bill_of_lading_id"
    t.integer  "shipping_line_id"
    t.date     "exemption_code_date"
    t.date     "kebs_exemption_code_date"
    t.string   "customs_entry_number"
    t.date     "customs_entry_date"
    t.date     "duty_payment_date"
    t.date     "sgr_move_date"
    t.date     "icd_arrival_date"
    t.date     "loaded_out_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country_of_origin"
    t.boolean  "comesa"
    t.float    "fob"
    t.string   "fob_currency"
    t.float    "freight"
    t.string   "freight_currency"
    t.float    "other_charges"
    t.string   "other_currency"
    t.date     "copy_documents_date"
    t.date     "original_documents_date"
  end

  add_index "local_imports", ["bill_of_lading_id"], name: "index_local_imports_on_bill_of_lading_id", using: :btree
  add_index "local_imports", ["customer_id"], name: "index_local_imports_on_customer_id", using: :btree
  add_index "local_imports", ["shipping_line_id"], name: "index_local_imports_on_shipping_line_id", using: :btree

  create_table "location_dates", force: true do |t|
    t.integer  "truck_id"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
  end

  add_index "location_dates", ["truck_id"], name: "index_location_dates_on_truck_id", using: :btree

  create_table "make_models", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mechanics", force: true do |t|
    t.string   "name"
    t.date     "date_of_employment"
    t.string   "designation"
    t.float    "salary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
  end

  add_index "mechanics", ["created_by_id"], name: "index_mechanics_on_created_by_id", using: :btree

  create_table "movements", force: true do |t|
    t.string   "booking_number"
    t.string   "truck_number"
    t.string   "vessel_targeted"
    t.string   "port_of_discharge"
    t.string   "port_of_loading"
    t.date     "estimate_delivery"
    t.string   "movement_type"
    t.string   "custom_seal"
    t.string   "remarks"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "w_o_number"
    t.string   "bill_of_lading_id"
    t.string   "clearing_agent"
    t.string   "clearing_agent_payment"
    t.string   "transporter_payment"
    t.date     "transporter_invoice_date"
    t.string   "transporter_invoice_number"
    t.date     "clearing_agent_invoice_date"
    t.string   "clearing_agent_invoice_number"
    t.integer  "vendor_id"
    t.integer  "clearing_agent_id"
    t.string   "bl_number"
  end

  add_index "movements", ["bill_of_lading_id"], name: "index_movements_on_bill_of_lading_id", using: :btree
  add_index "movements", ["clearing_agent_id"], name: "index_movements_on_clearing_agent_id", using: :btree
  add_index "movements", ["vendor_id"], name: "index_movements_on_vendor_id", using: :btree

  create_table "particulars", force: true do |t|
    t.integer  "invoice_id"
    t.string   "name"
    t.integer  "rate"
    t.integer  "quantity"
    t.integer  "subtotal",   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "particulars", ["invoice_id"], name: "index_particulars_on_invoice_id", using: :btree

  create_table "payments", force: true do |t|
    t.date     "date_of_payment"
    t.integer  "amount"
    t.string   "mode_of_payment"
    t.string   "reference"
    t.string   "remarks"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "customer_id"
    t.integer  "vendor_id"
    t.string   "currency"
  end

  add_index "payments", ["customer_id"], name: "index_payments_on_customer_id", using: :btree
  add_index "payments", ["type"], name: "index_payments_on_type", using: :btree
  add_index "payments", ["vendor_id"], name: "index_payments_on_vendor_id", using: :btree

  create_table "petty_cashes", force: true do |t|
    t.date     "date"
    t.text     "description"
    t.string   "transaction_type"
    t.decimal  "transaction_amount", precision: 15, scale: 2
    t.decimal  "available_balance",  precision: 15, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expense_head_id"
    t.integer  "truck_id"
    t.integer  "created_by_id"
    t.string   "account_type"
  end

  add_index "petty_cashes", ["account_type"], name: "index_petty_cashes_on_account_type", using: :btree
  add_index "petty_cashes", ["created_by_id"], name: "index_petty_cashes_on_created_by_id", using: :btree
  add_index "petty_cashes", ["date"], name: "index_petty_cashes_on_date", using: :btree
  add_index "petty_cashes", ["expense_head_id"], name: "index_petty_cashes_on_expense_head_id", using: :btree
  add_index "petty_cashes", ["truck_id"], name: "index_petty_cashes_on_truck_id", using: :btree

  create_table "purchase_order_items", force: true do |t|
    t.integer  "truck_id"
    t.integer  "spare_part_id"
    t.integer  "purchase_order_id"
    t.string   "part_make"
    t.integer  "quantity"
    t.float    "price"
    t.float    "total_price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "of_type"
    t.integer  "original_id"
  end

  add_index "purchase_order_items", ["purchase_order_id"], name: "index_purchase_order_items_on_purchase_order_id", using: :btree
  add_index "purchase_order_items", ["spare_part_id"], name: "index_purchase_order_items_on_spare_part_id", using: :btree
  add_index "purchase_order_items", ["truck_id"], name: "index_purchase_order_items_on_truck_id", using: :btree

  create_table "purchase_orders", force: true do |t|
    t.string   "number"
    t.date     "date"
    t.float    "total_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_id"
    t.string   "inv_number"
    t.date     "inv_date"
  end

  add_index "purchase_orders", ["date"], name: "index_purchase_orders_on_date", using: :btree
  add_index "purchase_orders", ["supplier_id"], name: "index_purchase_orders_on_supplier_id", using: :btree

  create_table "remarks", force: true do |t|
    t.integer  "category"
    t.datetime "date"
    t.string   "remarkable_type"
    t.integer  "remarkable_id"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "remarks", ["date"], name: "index_remarks_on_date", using: :btree
  add_index "remarks", ["remarkable_type", "remarkable_id"], name: "index_remarks_on_remarkable_type_and_remarkable_id", using: :btree

  create_table "repair_heads", force: true do |t|
    t.string   "name"
    t.boolean  "is_active",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "req_parts", force: true do |t|
    t.integer  "spare_part_id"
    t.text     "description"
    t.integer  "mechanic_id"
    t.float    "price"
    t.integer  "quantity"
    t.float    "total_cost"
    t.integer  "req_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "original_id"
  end

  add_index "req_parts", ["mechanic_id"], name: "index_req_parts_on_mechanic_id", using: :btree
  add_index "req_parts", ["req_sheet_id"], name: "index_req_parts_on_req_sheet_id", using: :btree
  add_index "req_parts", ["spare_part_id"], name: "index_req_parts_on_spare_part_id", using: :btree

  create_table "req_sheets", force: true do |t|
    t.string   "ref_number"
    t.date     "date"
    t.float    "value"
    t.integer  "truck_id"
    t.integer  "km"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "req_sheets", ["date"], name: "index_req_sheets_on_date", using: :btree
  add_index "req_sheets", ["truck_id"], name: "index_req_sheets_on_truck_id", using: :btree

  create_table "spare_part_categories", force: true do |t|
    t.string   "name"
    t.integer  "sub_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spare_part_ledgers", force: true do |t|
    t.date     "date"
    t.integer  "spare_part_id"
    t.integer  "original_id"
    t.integer  "quantity"
    t.string   "inward_outward"
    t.string   "receipt_type"
    t.integer  "receipt_id"
    t.boolean  "is_adjustment"
    t.integer  "balance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spare_part_vendors", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "contact_person"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spare_parts", force: true do |t|
    t.string   "product_name"
    t.text     "description"
    t.integer  "spare_part_category_id"
    t.integer  "spare_part_sub_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.boolean  "is_parent"
  end

  add_index "spare_parts", ["is_parent"], name: "index_spare_parts_on_is_parent", using: :btree
  add_index "spare_parts", ["product_name"], name: "index_spare_parts_on_product_name", using: :btree
  add_index "spare_parts", ["spare_part_category_id"], name: "index_spare_parts_on_spare_part_category_id", using: :btree

  create_table "status_dates", force: true do |t|
    t.date     "under_loading_process"
    t.date     "truck_allocated"
    t.date     "loaded_out_of_port"
    t.date     "arrived_at_border"
    t.date     "departed_from_border"
    t.date     "arrived_at_destination"
    t.date     "delivered"
    t.date     "ready_to_load"
    t.integer  "import_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "trip_date"
  end

  create_table "suppliers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trucks", force: true do |t|
    t.string   "type_of"
    t.string   "reg_number"
    t.date     "year_of_purchase"
    t.date     "insurance_expiry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "location"
    t.integer  "current_import_item_id"
    t.integer  "fuel_capacity"
    t.string   "trailer_reg_number"
    t.decimal  "insurance_premium_amt_yearly",            precision: 10, scale: 2
    t.string   "driver_name",                  limit: 50
    t.integer  "make_model_id"
    t.boolean  "is_active",                                                        default: true
  end

  add_index "trucks", ["make_model_id"], name: "index_trucks_on_make_model_id", using: :btree
  add_index "trucks", ["reg_number"], name: "index_trucks_on_reg_number", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "is_active",              default: true
    t.string   "role"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vendor_ledgers", force: true do |t|
    t.integer  "vendor_id"
    t.integer  "voucher_id"
    t.string   "voucher_type"
    t.float    "amount"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "paid",         default: 0.0
    t.string   "currency"
  end

  add_index "vendor_ledgers", ["vendor_id"], name: "index_vendor_ledgers_on_vendor_id", using: :btree

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "vendor_type"
    t.string   "address_to"
  end

end
