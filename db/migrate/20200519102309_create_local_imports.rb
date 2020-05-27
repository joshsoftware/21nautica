class CreateLocalImports < ActiveRecord::Migration
  def change
    create_table :local_imports do |t|
      t.string     :bl_number
      t.string     :description
      t.integer    :shipper
      t.string     :equipment_type
      t.integer    :quantity
      t.boolean    :exemption_code_needed
      t.boolean    :kebs_exemption_code_needed
      t.string     :vessel_name
      t.date       :estimated_arrival
      t.string     :gwt
      t.string     :fpd
      t.string     :idf_number
      t.date       :idf_date
      t.string     :invoice_number
      t.string     :reference_number
      t.date       :reference_date
      t.string     :customer_reference
      t.string     :status
      t.belongs_to :customer, index: true
      t.belongs_to :bill_of_lading, index: true
      t.belongs_to :shipping_line, index: true
      t.date       :exemption_code_date
      t.date       :kebs_exemption_code_date
      t.string     :customs_entry_number
      t.date       :customs_entry_date
      t.date       :duty_payment_date
      t.date       :sgr_move_date
      t.date       :icd_arrival_date
      t.date       :loaded_out_date
      t.timestamps
    end
  end
end
