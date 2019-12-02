namespace :spare_part_ledger do
  desc "Filling the spare part ledger"
  task fill: :environment do
    SparePart.all.each do |spare_part|
      p "Filling ledger for spare part id - #{spare_part.id}"
      SparePartLedger.adjust_whole_ledger(spare_part.id)
    end
    p "Filled the spare part ledger"
  end

end
