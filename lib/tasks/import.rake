namespace :import do
  desc 'Set bl_received to 0 for existing imports(one time task)'
  task set_bl_received_type_to_Copy_default: :environment do
    Import.update_all(bl_received_type: 0)
  end
end
