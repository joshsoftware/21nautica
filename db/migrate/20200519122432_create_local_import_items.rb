class CreateLocalImportItems < ActiveRecord::Migration
  def change
    create_table :local_import_items do |t|
      t.date        :exemption_code_date
      t.date        :kebs_exemption_code_date
      t.string      :customs_entry_number
      t.date        :customs_entry_date
      t.date        :duty_payment_date
      t.date        :sgr_move_date
      t.date        :icd_arrival_date
      t.date        :loaded_out_date
      t.date        :offloading_date
      t.string      :container_number
      t.string      :status
      t.belongs_to  :local_import, index: true
      t.belongs_to  :truck, index: true
      t.timestamps
    end
  end
end
